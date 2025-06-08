#!/bin/bash

# Download model: deepseek-ai/deepseek-coder-6.7b-instruct
MODEL="deepseek-ai/deepseek-coder-6.7b-instruct"
MODEL_DIR="models/deepseek-coder-6.7b-instruct"

if [ ! -d "$MODEL_DIR" ]; then
    echo "Downloading model: $MODEL"
    python3 scripts/download_model.py --model "$MODEL" --output "$MODEL_DIR"
else
    echo "Model already exists at $MODEL_DIR, skipping download."
fi
