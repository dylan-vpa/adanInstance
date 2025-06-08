#!/bin/bash

# Create necessary directories
mkdir -p models/mistral-mixtral
mkdir -p vllm/config
mkdir -p vllm/logs
mkdir -p moderador-api/agents

# Set up vLLM environment
cat > vllm/config/settings.env << EOL
# Model Configuration
MODEL_NAME=mistralai/Mixtral-8x7B-Instruct-v0.1
MODEL_PATH=/app/models/mistral-mixtral
MAX_MODEL_LEN=4096
QUANTIZATION=awq

# Server Configuration
HOST=0.0.0.0
PORT=8000
WORKERS=1
MAX_BATCH_SIZE=32
MAX_BATCH_TOKENS=4096

# GPU Configuration
GPU_MEMORY_UTILIZATION=0.9
TENSOR_PARALLEL_SIZE=1

# Logging
LOG_LEVEL=INFO
LOG_FILE=/app/logs/vllm.log
EOL

# Set up moderador-api environment
cat > moderador-api/.env << EOL
VLLM_HOST=localhost
VLLM_PORT=8000
API_HOST=0.0.0.0
API_PORT=8001
EOL

# Set permissions
chmod +x scripts/*.sh

echo "Setup completed successfully!" 