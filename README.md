# Sistema de Fine-tuning para Modelos Ollama

Este sistema te permite hacer fine-tuning de tus modelos basados en DeepSeek-R1 creados con Ollama, usando datos específicos para cada agente.

## Estructura de Directorios

```
proyecto/
├── modelfiles/                 # Model definition files (one per agent)
├── datasets/                   # Training data for each agent
│   ├── ana/
│   │   ├── train.json
│   │   └── eval.json
│   ├── andu/
│   │   ├── train.json
│   │   └── eval.json
│   ├── ben/
│   │   ├── train.json
│   │   └── eval.json
│   ├── ... (one folder per agent, see list below)
├── scripts/                    # System scripts
│   ├── setup.py
│   ├── finetune_model.py
│   ├── convert_to_ollama.py
│   └── batch_finetune.py
├── models_finetuned/           # Fine-tuned models
├── models_ollama/              # Models converted for Ollama
└── logs/                       # Training logs
```

**Agentes:**  
Crea una subcarpeta en `datasets/` para cada uno de estos agentes (usa el nombre antes de `:latest`):

```
zara, tita_vp_administrativo, tom, sofia_success, sofia_mentora, sam, ray, oliver, noah, milo_documentador, nia, mila, mia, maya, max, luna_inversionista, lucas, liam_inversionista, leo, julia, kai, jack, isa, gaby, goga_mentora, eva_vpmarketing, ethan_soporte, ema_producto, dylan, diego_inversionista, dany_tecnicocloud, ben, andu, ana, alex, Modelfile_GER_DE_Zoe, Modelfile_GER_DE_Elsy, Modelfile_GER_DE_Bella, Modelfile_Adan_CEO
```

Cada carpeta de agente debe contener:
- `train.json` (tus datos de entrenamiento)
- `eval.json` (tus datos de evaluación)

**Ejemplo:**
```
datasets/sofia_mentora/train.json
datasets/sofia_mentora/eval.json
```

Debes agregar tus propios datos a estos archivos.

## Uso del Sistema

### 1. Preparar los Datos
Coloca tus archivos `train.json` y `eval.json` en la carpeta de cada agente dentro de `datasets/`.

### 2. Fine-tuning Individual
```bash
# Fine-tuning de un modelo específico
python scripts/finetune_model.py --agent_name sofia_mentora --epochs 3 --batch_size 4

# Con parámetros personalizados
python scripts/finetune_model.py --agent_name elsy --epochs 5 --batch_size 2 --learning_rate 2e-4
```

### 3. Fine-tuning por Lotes
```bash
# Fine-tuning de todos los modelos
python scripts/batch_finetune.py

# Fine-tuning solo de modelos específicos
python scripts/batch_finetune.py --agents adan,elsy,bella
```

### 4. Convertir a Ollama
```bash
# Convertir modelo individual
python scripts/convert_to_ollama.py --agent_name adan

# Convertir todos los modelos fine-tuned
python scripts/convert_to_ollama.py --all
```

### 5. Crear Modelos en Ollama
```bash
# Script automatizado para crear todos los modelos
./create_finetuned_models.sh
```

## Parámetros de Fine-tuning

### Configuración Recomendada por Tipo de Agente

**Agentes Técnicos (IT, Analytics):**
- Epochs: 3-5
- Learning Rate: 1e-4
- Batch Size: 4-8

**Agentes de Marketing/Ventas:**
- Epochs: 4-6
- Learning Rate: 2e-4
- Batch Size: 2-4

**Agentes Ejecutivos/Estratégicos:**
- Epochs: 5-8
- Learning Rate: 1e-4
- Batch Size: 4-6

## Monitoreo

### Logs de Entrenamiento
```bash
# Ver progreso en tiempo real
tail -f logs/[agent_name]_training.log

# Ver métricas de evaluación
cat logs/[agent_name]_eval_results.json
```

### Validación de Modelos
```bash
# Probar modelo antes de convertir
python scripts/test_model.py --agent_name adan --prompt "¿Cuál es tu estrategia como CEO?"
```

## Troubleshooting

### Error de Memoria GPU
- Reducir batch_size a 1 o 2
- Usar `--use_gradient_checkpointing`
- Activar `--load_in_4bit`

### Modelos Muy Grandes
- Usar LoRA con rank más bajo (r=4 o r=8)
- Implementar DeepSpeed ZeRO

### Datos Insuficientes
- Mínimo 50 ejemplos por agente
- Recomendado 200+ ejemplos
- Usar data augmentation si es necesario

## Personalización Avanzada

### Modificar Arquitectura LoRA
Editar en `finetune_model.py`:
```python
peft_config = LoraConfig(
    r=16,  # Rank - más alto = más parámetros
    lora_alpha=32,  # Scaling factor
    target_modules=["q_proj", "k_proj", "v_proj", "o_proj"],
    lora_dropout=0.1,
)
```

### Templates Personalizados
Cada agente puede tener su template en `templates/[agent_name]_template.txt`

## Scripts Útiles

### Backup de Modelos
```bash
./backup_models.sh  # Respalda modelos originales y fine-tuned
```

### Cleanup
```bash
./cleanup.sh  # Limpia archivos temporales y logs antiguos
```

### Benchmarking
```bash
python scripts/benchmark_models.py  # Compara rendimiento antes/después
```

## Notas Importantes

1. **Siempre hacer backup** de tus modelos originales antes del fine-tuning
2. **Validar datos** antes del entrenamiento - calidad > cantidad
3. **Monitorear overfitting** - usar early stopping si es necesario
4. **Documentar cambios** - mantener log de configuraciones exitosas
5. **Probar incrementalmente** - empezar con pocos epochs y aumentar gradualmente

## Soporte

Para problemas específicos:
1. Revisar logs en `logs/`
2. Verificar configuración de GPU con `nvidia-smi`
3. Validar formato de datos con el script de validación
4. Consultar documentación de Unsloth/Transformers para errores específicos