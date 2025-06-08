#!/bin/bash

# Check if HUGGING_FACE_TOKEN is set
if [ -z "$HUGGING_FACE_TOKEN" ]; then
    echo "Error: HUGGING_FACE_TOKEN environment variable is not set"
    echo "Please set it with: export HUGGING_FACE_TOKEN=your_token_here"
    exit 1
fi

# Available models
declare -A MODELS=(
    ["1"]="mistralai/Mixtral-8x7B-Instruct-v0.1"
    ["2"]="mistralai/Mistral-7B-Instruct-v0.2"
    ["3"]="meta-llama/Llama-2-7b-chat-hf"
    ["4"]="tiiuae/falcon-7b-instruct"
)

# Show available models
echo "Available models:"
echo "1) Mixtral-8x7B-Instruct-v0.1"
echo "2) Mistral-7B-Instruct-v0.2"
echo "3) Llama-2-7b-chat-hf"
echo "4) Falcon-7b-instruct"
echo

# Get user selection
read -p "Select a model (1-4): " model_choice

# Validate selection
if [[ ! "$model_choice" =~ ^[1-4]$ ]]; then
    echo "Invalid selection. Please choose a number between 1 and 4."
    exit 1
fi

# Get model ID
model_id=${MODELS[$model_choice]}
model_dir=$(echo $model_id | cut -d'/' -f2)

# Create models directory if it doesn't exist
mkdir -p "models/$model_dir"

# Install huggingface_hub if not already installed
pip install --upgrade huggingface_hub

# Download the model
echo "Downloading $model_id from Hugging Face..."
python3 -c "
from huggingface_hub import snapshot_download
import os

model_id = '$model_id'
local_dir = 'models/$model_dir'

# Download the model
snapshot_download(
    repo_id=model_id,
    local_dir=local_dir,
    token=os.environ['HUGGING_FACE_TOKEN'],
    ignore_patterns=['*.md', '*.txt', '*.json', '*.yaml', '*.yml'],
    local_dir_use_symlinks=False
)
"

# Check if download was successful
if [ $? -eq 0 ]; then
    echo "Model downloaded successfully!"
    echo "Model files are located in: models/$model_dir"
    
    # Update settings.env with the selected model
    sed -i "s|MODEL_NAME=.*|MODEL_NAME=$model_id|" vllm/config/settings.env
    sed -i "s|MODEL_PATH=.*|MODEL_PATH=/app/models/$model_dir|" vllm/config/settings.env
    
    echo "Updated vLLM configuration with selected model."
else
    echo "Error: Failed to download the model"
    exit 1
fi 