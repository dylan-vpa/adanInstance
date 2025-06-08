#!/bin/bash

# Start vLLM server locally using vllm CLI
echo "Starting vLLM server locally..."
cd vllm

# Create and activate virtual environment if not exists
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

# Install dependencies
pip install -r ../requirements.txt

# Run the vLLM server in background using vllm CLI
nohup vllm serve ${MODEL_NAME:-"mistralai/Mixtral-8x7B-Instruct-v0.1"} --port 8000 > vllm.log 2>&1 &

cd ..

# Wait for vLLM server to be ready
echo "Waiting for vLLM server to be ready..."
sleep 10

# Start moderador-api locally
echo "Starting moderador-api..."
cd moderador-api

# Create and activate virtual environment if not exists
if [ ! -d "venv" ]; then
    python3 -m venv venv
fi
source venv/bin/activate

pip install -r requirements.txt

uvicorn main:app --host 0.0.0.0 --port 8004 &

cd ..

echo "All services started successfully!"
echo "vLLM server running on http://localhost:8000"
echo "Moderador API running on http://localhost:8004"
