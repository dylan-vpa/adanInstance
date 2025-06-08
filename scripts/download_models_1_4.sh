#!/bin/bash

# Download model 1: mistralai/Mixtral-8x7B-Instruct-v0.1
MODEL_1="mistralai/Mixtral-8x7B-Instruct-v0.1"
MODEL_1_DIR="models/Mixtral-8x7B-Instruct-v0.1"

if [ ! -d "$MODEL_1_DIR" ]; then
    echo "Downloading model 1: $MODEL_1"
    python3 scripts/download_model.py --model "$MODEL_1" --output "$MODEL_1_DIR"
else
    echo "Model 1 already exists at $MODEL_1_DIR, skipping download."
fi

# Download model 4: tiiuae/falcon-7b-instruct
MODEL_4="tiiuae/falcon-7b-instruct"
MODEL_4_DIR="models/falcon-7b-instruct"

if [ ! -d "$MODEL_4_DIR" ]; then
    echo "Downloading model 4: $MODEL_4"
    python3 scripts/download_model.py --model "$MODEL_4" --output "$MODEL_4_DIR"
else
    echo "Model 4 already exists at $MODEL_4_DIR, skipping download."
fi
