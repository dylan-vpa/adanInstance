#!/bin/bash
MODELDIR="./models_ollama"

for modelfile in "$MODELDIR"/*; do
  agent_name=$(basename "$modelfile")
  echo "Creating Ollama model: $agent_name"
  ollama create "$agent_name" -f "$modelfile"
done
