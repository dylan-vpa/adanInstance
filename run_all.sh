#!/bin/bash

# 1. Ejecutar el setup para preparar carpetas, infobase y datasets de ejemplo
echo "[INFO] Ejecutando setup inicial..."
python scripts/setup.py

# 2. Validar los datasets generados
echo "[INFO] Validando datasets..."
python scripts/validate_datasets.py

# 3. (Opcional) Editar datasets manualmente si lo deseas
echo "[INFO] Si deseas, edita los archivos en datasets/[agente]/train.json y eval.json antes de continuar."
echo "[INFO] Presiona Enter para continuar o Ctrl+C para abortar y editar manualmente."
read

# 4. Instalar dependencias (si no están instaladas)
echo "[INFO] Instalando dependencias (si es necesario)..."
pip install -r requirements.txt

# 5. Entrenar todos los agentes (fine-tuning por lotes)
echo "[INFO] Iniciando fine-tuning por lotes para todos los agentes..."
python scripts/batch_finetune.py

# 6. Convertir todos los modelos fine-tuned a formato Ollama
echo "[INFO] Convirtiendo todos los modelos fine-tuned a formato Ollama..."
python scripts/convert_to_ollama.py --all

# 7. Crear los modelos en Ollama usando los Modelfiles generados
echo "[INFO] Creando modelos en Ollama..."
bash createAgents.sh

echo "[OK] Proceso completo. Todos los agentes han sido entrenados y convertidos para Ollama."
