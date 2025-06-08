#!/bin/bash

# Start vLLM server
echo "Starting vLLM server..."
cd vllm
docker-compose up -d

# Wait for vLLM server to be ready
echo "Waiting for vLLM server to be ready..."
sleep 10

# Start moderador-api
echo "Starting moderador-api..."
cd ../moderador-api
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
uvicorn main:app --host 0.0.0.0 --port 8001 &

echo "All services started successfully!"
echo "vLLM server running on http://localhost:8000"
echo "Moderador API running on http://localhost:8001" 