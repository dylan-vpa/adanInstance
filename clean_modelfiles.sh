#!/bin/bash

# Script para limpiar modelfiles removiendo adaptadores LoRA

echo "🧹 Limpiando modelfiles..."
echo ""

# Crear directorio de backup
mkdir -p modelfiles_backup
cp modelfiles/* modelfiles_backup/

echo "📁 Backup creado en modelfiles_backup/"
echo ""

# Lista de modelfiles a limpiar
MODELFILES=(
    "Modelfile_ADAN"
    "Modelfile_EVA"
    "Modelfile_Tita"
    "Modelfile_Dany"
    "Modelfile_Dylan"
    "Modelfile_Vito"
    "Modelfile_Enzo"
    "Modelfile_Sofia"
    "Modelfile_Goga"
    "Modelfile_Andu"
    "Modelfile_Luna"
    "Modelfile_Liam"
    "Modelfile_Diego"
    "Modelfile_Milo"
    "Modelfile_Hana"
    "Modelfile_Elsy"
    "Modelfile_Bella"
    "Modelfile_Moderator"
)

# Función para limpiar un modelfile
clean_modelfile() {
    local file="$1"
    local temp_file="${file}.tmp"
    
    echo "🧹 Limpiando: $file"
    
    # Remover líneas ADAPTER y crear archivo temporal
    grep -v "^ADAPTER" "modelfiles/$file" > "modelfiles/$temp_file"
    
    # Reemplazar archivo original
    mv "modelfiles/$temp_file" "modelfiles/$file"
    
    echo "   ✅ Limpiado: $file"
}

# Limpiar todos los modelfiles
for modelfile in "${MODELFILES[@]}"; do
    if [ -f "modelfiles/$modelfile" ]; then
        clean_modelfile "$modelfile"
    else
        echo "⚠️  Archivo no encontrado: $modelfile"
    fi
done

echo ""
echo "🎉 Limpieza completada!"
echo ""
echo "📋 Archivos limpiados:"
ls -la modelfiles/Modelfile_*

echo ""
echo "🔧 Ahora puedes ejecutar:"
echo "   ./create_ollama_models.sh" 