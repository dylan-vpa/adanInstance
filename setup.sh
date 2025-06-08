#!/bin/bash

set -e

BASE_DIR="$HOME/Adan"
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
install_if_missing pip pip
install_if_missing python3-venv python3-venv
install_if_missing docker docker.io

# Verificar NVIDIA Container Toolkit
if ! docker info | grep -q 'nvidia'; then
  echo "⚠️  NVIDIA Container Toolkit no encontrado."
  read -p "¿Quieres instalarlo ahora? (s/n): " install_nvidia
  if [[ "$install_nvidia" == "s" ]]; then
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
    curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list
    sudo apt update
    sudo apt install -y nvidia-docker2
    sudo systemctl restart docker
    echo "✅ NVIDIA Container Toolkit instalado y Docker reiniciado."
  else
    echo "⚠️  Continúas sin aceleración GPU por ahora."
  fi
else
  echo "✅ NVIDIA Container Toolkit ya está disponible."
fi

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
echo "💡 Usa 'source ~/Adan/moderador-api/venv/bin/activate' para activar el entorno."



