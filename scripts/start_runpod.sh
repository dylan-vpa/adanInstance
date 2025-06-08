#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

# Set default ports if not provided by RunPod
export PORT_HTTP=${PORT_HTTP:-80}
export PORT_HTTPS=${PORT_HTTPS:-443}
export PORT_VLLM=${PORT_VLLM:-8000}
export PORT_API=${PORT_API:-8001}

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

# Start services
echo "Starting services..."
docker-compose up -d

# Wait for services to be ready
echo "Waiting for services to be ready..."
sleep 10

# Check service status
echo "Checking service status..."
docker-compose ps

# Print access information
echo "Services are running!"
echo "API available at: http://${RUNPOD_PUBLIC_IP}:${PORT_API}"
echo "vLLM server at: http://${RUNPOD_PUBLIC_IP}:${PORT_VLLM}"
echo "Nginx at: http://${RUNPOD_PUBLIC_IP}:${PORT_HTTP}"

# Keep the container running
tail -f nginx/logs/access.log 