#!/bin/bash

MODELDIR="./modelfiles"

for modelfile in "$MODELDIR"/*; do
  agent_name=$(basename "$modelfile")
  echo "Creando agente: $agent_name"
  ollama create "$agent_name" -f "$modelfile"
done