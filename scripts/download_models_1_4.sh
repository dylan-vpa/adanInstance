#!/bin/bash

# Download model: mistralai/Devstral-Small-2505
MODEL="mistralai/Devstral-Small-2505"
MODEL_DIR="models/Devstral-Small-2505"

if [ ! -d "$MODEL_DIR" ]; then
    echo "Downloading model: $MODEL"
    python3 scripts/download_model.py --model "$MODEL" --output "$MODEL_DIR"
else
    echo "Model already exists at $MODEL_DIR, skipping download."
fi
