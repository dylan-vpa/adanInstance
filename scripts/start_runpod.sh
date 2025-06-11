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

# Start vLLM server locally
echo "Starting vLLM server locally..."
cd vllm

# Create and activate virtual environment if not exists
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# Upgrade pip and install vllm and other dependencies
pip install --upgrade pip
pip install vllm
pip install -r ../requirements.txt

# Verify vllm executable path
VLLM_EXEC=./venv/bin/vllm
if [ ! -f "$VLLM_EXEC" ]; then
    echo "vllm executable not found at $VLLM_EXEC"
    exit 1
fi

# Run the vLLM server in background using vllm CLI from virtual environment
nohup $VLLM_EXEC serve ${MODEL_NAME:-"mistralai/Mixtral-8x7B-Instruct-v0.1"} --port 8000 > vllm.log 2>&1 &

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

uvicorn main:app --host 0.0.0.0 --port 8004 &

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
