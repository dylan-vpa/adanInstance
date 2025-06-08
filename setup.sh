#!/bin/bash

set -e

BASE_DIR="$HOME/adanInstance"
MOD_DIR="$BASE_DIR/moderador-api"
VLLM_DIR="$BASE_DIR/vllm/config"
MODELS_DIR="$BASE_DIR/models"

echo "🚀 Iniciando instalación y verificación del entorno para ADAN..."

# Función para instalar paquetes si faltan
install_if_missing() {
  if ! command -v $1 &> /dev/null; then
    echo "📦 Instalando $1..."
    sudo apt update && sudo apt install -y $2
  else
    echo "✅ $1 ya está instalado."
  fi
}

# Verificar e instalar dependencias del sistema
install_if_missing python3 python3
install_if_missing pip3 python3-pip
install_if_missing python3-venv python3-venv

# Crear estructura de carpetas
echo "📁 Verificando carpetas base..."
mkdir -p "$MODELS_DIR" "$VLLM_DIR" "$MOD_DIR/agents"

# Crear entorno virtual
echo "🐍 Configurando entorno virtual en $MOD_DIR..."
cd "$MOD_DIR"
if [ ! -d "venv" ]; then
  python3 -m venv venv
fi
source venv/bin/activate

# Instalar dependencias Python
echo "📦 Instalando dependencias FastAPI..."
pip install --upgrade pip
pip install fastapi uvicorn httpx pydantic transformers accelerate

# Crear requirements.txt
cat <<EOF > requirements.txt
fastapi
uvicorn
httpx
pydantic
transformers
accelerate
EOF

echo "✅ Todo listo en $BASE_DIR"
echo "💡 Usa 'source ~/adanInstance/moderador-api/venv/bin/activate' para activar el entorno."
