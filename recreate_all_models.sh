#!/bin/bash

echo "🚀 Recreando TODOS los modelos con modelfiles actualizados..."

# Lista de modelos a recrear
models=(
    "Modelfile_ADAN"
    "eva_vpmarketing"
    "tita_vp_administrativo"
    "dany_tecnicocloud"
    "ethan_soporte"
    "vito_fullstack"
    "ema_producto"
    "sofia_mentora"
    "goga_mentora"
    "andu_mentora"
    "luna_inversionista"
    "liam_inversionista"
    "diego_inversionista"
    "milo_documentador"
    "Modelfile_GER_DE_Zoe"
    "Modelfile_GER_DE_Elsy"
    "Modelfile_GER_DE_Bella"
    "Modelfile_Moderator"
)

echo "📋 Modelos a recrear: ${#models[@]}"

for model in "${models[@]}"; do
    echo "🔄 Recreando modelo: $model"
    
    # Remover modelo existente si existe
    if ollama list | grep -q "$model"; then
        echo "🗑️  Removiendo modelo existente: $model"
        ollama rm "$model" 2>/dev/null || true
    fi
    
    # Crear nuevo modelo
    if [[ "$model" == "eva_vpmarketing" ]]; then
        ollama create "$model" -f modelfiles/Modelfile_EVA
    elif [[ "$model" == "Modelfile_ADAN" ]]; then
        ollama create "$model" -f modelfiles/Modelfile_ADAN
    elif [[ "$model" == "Modelfile_Moderator" ]]; then
        ollama create "$model" -f modelfiles/Modelfile_Moderator
    else
        # Para otros modelos, usar el nombre del archivo
        modelfile_name="Modelfile_${model#Modelfile_}"
        if [[ -f "modelfiles/$modelfile_name" ]]; then
            ollama create "$model" -f "modelfiles/$modelfile_name"
        else
            echo "⚠️  Modelfile no encontrado para: $model"
            continue
        fi
    fi
    
    if [ $? -eq 0 ]; then
        echo "✅ Modelo $model recreado exitosamente"
    else
        echo "❌ Error recreando modelo $model"
    fi
    
    echo "---"
done

echo "🎉 ¡Proceso completado!"
echo "📊 Modelos recreados: $(ollama list | wc -l)"
echo ""
echo "🧪 Para probar, envía este mensaje en el chat:"
echo "   'Necesito un MVP web para mi startup'"
echo ""
echo "💡 Los agentes ahora preguntarán antes de crear entregables" 