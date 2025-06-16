#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set default ports if not provided by RunPod
export PORT_HTTP=${PORT_HTTP:-80}
export PORT_HTTPS=${PORT_HTTPS:-443}
export PORT_VLLM=${PORT_VLLM:-8000}
export PORT_API=${PORT_API:-8004}

# Create necessary directories
mkdir -p models
mkdir -p nginx/ssl
mkdir -p nginx/logs
mkdir -p vllm/logs
mkdir -p fine-tuning/models

# Check for GPU
if [ -z "$RUNPOD_GPU_ID" ]; then
    echo "Warning: No GPU ID provided by RunPod"
fi

# Hugging Face login for gated model access
echo "Logging into Hugging Face CLI..."
if ! command -v huggingface-cli &> /dev/null
then
    echo "huggingface-cli could not be found, installing..."
    pip install huggingface_hub
fi

# Use HUGGINGFACE_TOKEN environment variable for automatic login if set
if [ -n "$HUGGINGFACE_TOKEN" ]; then
    echo "Using HUGGINGFACE_TOKEN environment variable for Hugging Face login..."
    huggingface-cli login --token $HUGGINGFACE_TOKEN
else
    echo "HUGGINGFACE_TOKEN environment variable not set. Please set it in your RunPod instance environment variables."
    echo "Exiting to avoid unauthorized access."
    exit 1
fi

echo "Current directory: $(pwd)"
# Start vLLM server locally
echo "Starting vLLM server locally..."
cd vllm || { echo "Failed to cd into vllm directory"; exit 1; }
echo "Current directory after cd: $(pwd)"

# Create and activate virtual environment if not exists
if [ -d "venv" ]; then
    echo "Removing incomplete or existing virtual environment at $(pwd)/venv"
    rm -rf venv
fi

echo "Creating virtual environment in $(pwd)/venv"
# Try python3 -m venv first
python3 -m venv venv
if [ $? -ne 0 ]; then
    echo "Failed to create virtual environment using python3 -m venv, trying virtualenv..."
    # Try virtualenv as fallback
    virtualenv venv
    if [ $? -ne 0 ]; then
        echo "Failed to create virtual environment using virtualenv"
        exit 1
    fi
fi

if [ ! -f "venv/bin/activate" ]; then
    echo "Virtual environment activation script not found at venv/bin/activate"
    echo "Listing contents of venv/bin:"
    ls -l venv/bin
    exit 1
fi

source venv/bin/activate

# Upgrade pip and install vllm and other dependencies
pip install --upgrade pip
if [ $? -ne 0 ]; then
    echo "Failed to upgrade pip"
    exit 1
fi

pip install vllm
if [ $? -ne 0 ]; then
    echo "Failed to install vllm"
    exit 1
fi

pip install -r ../requirements.txt
if [ $? -ne 0 ]; then
    echo "Failed to install requirements"
    exit 1
fi

# Verify vllm executable path
VLLM_EXEC="$(pwd)/venv/bin/vllm"
if [ ! -f "$VLLM_EXEC" ]; then
    echo "vllm executable not found at $VLLM_EXEC"
    echo "Listing contents of venv/bin:"
    ls -l venv/bin
    exit 1
fi

# Download the model before starting the server
# Using a lighter model for better performance
LIGHT_MODEL="deepseek-ai/deepseek-coder-6.7b-instruct"
echo "Downloading lighter model ${MODEL_NAME:-$LIGHT_MODEL}..."
python3 ../scripts/download_model.py --model ${MODEL_NAME:-$LIGHT_MODEL} --output ../models/deepseek-coder-6.7b-instruct --token $HUGGINGFACE_TOKEN

# Run the vLLM server in background using vllm CLI from virtual environment
nohup "$VLLM_EXEC" serve ${MODEL_NAME:-$LIGHT_MODEL} --port 8000 > vllm.log 2>&1 &

# Wait a few seconds for the server to start
sleep 10

cd ..

# Start moderador-api locally
echo "Starting moderador-api locally..."
cd moderador-api

# Create and activate virtual environment if not exists
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

pip install -r requirements.txt

pip install transformers

export VLLM_HOST=localhost
export VLLM_PORT=8000
export PYTHONPATH=$(pwd)

uvicorn main:app --host 0.0.0.0 --port 8004 > moderador-api.log 2>&1 &

cd ..

# Optionally start nginx locally if needed
# echo "Starting nginx..."
# sudo systemctl start nginx

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Print access information
echo "Services are running!"
echo "API available at: http://${RUNPOD_PUBLIC_IP}:${PORT_API}"
echo "vLLM server at: http://${RUNPOD_PUBLIC_IP}:${PORT_VLLM}"
echo "Nginx at: http://${RUNPOD_PUBLIC_IP}:${PORT_HTTP}"

# Keep the script running to keep services alive
tail -f vllm/vllm.log
