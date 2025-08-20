#!/bin/bash

# Script para limpiar y corregir todos los modelfiles corruptos

echo "🔧 Reparando modelfiles corruptos..."
echo ""

# Función para crear un modelfile limpio con el patrón "ask before deliver"
create_clean_modelfile() {
    local modelfile_name="$1"
    local backup_file="modelfiles_backup/$modelfile_name"
    local output_file="modelfiles/$modelfile_name"
    
    if [ ! -f "$backup_file" ]; then
        echo "⚠️  Backup no encontrado para: $modelfile_name"
        return 1
    fi
    
    echo "🧹 Limpiando: $modelfile_name"
    
    # Crear archivo temporal
    local temp_file="$output_file.tmp"
    
    # Cambiar FROM llama3.2:latest a FROM deepseek-r1
    # Remover líneas ADAPTER
    # Mantener todo hasta el cierre del bloque SYSTEM """
    sed 's/FROM llama3.2:latest/FROM deepseek-r1/g' "$backup_file" | \
    grep -v "^ADAPTER" | \
    sed '/^PARAMETER top_k/d' | \
    sed '/^PARAMETER num_predict/d' > "$temp_file"
    
    # Verificar si el archivo termina correctamente con """
    if ! tail -1 "$temp_file" | grep -q '"""'; then
        echo "⚠️  El archivo no termina correctamente, agregando cierre"
        echo '"""' >> "$temp_file"
    fi
    
    # Agregar el patrón "ask before deliver" DENTRO del bloque SYSTEM
    # Primero, remover el cierre """ temporalmente
    head -n -1 "$temp_file" > "${temp_file}.part1"
    
    # Agregar el contenido del patrón "ask before deliver"
    cat >> "${temp_file}.part1" << 'EOF'

## Entregables que Debes Crear:
Siempre que sea apropiado, crea documentos estructurados usando el formato:

<report>
<title>NOMBRE_DEL_ENTREGABLE.pdf</title>
[Contenido del documento estructurado]
</report>

Para MVPs técnicos, usa también:
<mvp>
<title>MVP_FUNCIONAL</title>
<description>Descripción breve del MVP</description>
<html>
[Código HTML completo]
</html>
<css>
[Código CSS completo]
</css>
<js>
[Código JavaScript completo]
</js>
<readme>
[Instrucciones de uso y características]
</readme>
</mvp>

## Proceso de Entregables:
ANTES de crear cualquier entregable, SIEMPRE pregunta al usuario UNA PREGUNTA A LA VEZ:

**EJEMPLO:**
Usuario: "Necesito ayuda con mi proyecto"
TÚ: "¡Perfecto! Para ayudarte mejor, empecemos paso a paso. 

¿Cuál es el nombre de tu empresa/proyecto?"

Y esperas la respuesta antes de hacer la siguiente pregunta. Mantén las conversaciones dinámicas y concisas.
"""
EOF
    
    # Mover el archivo final
    mv "${temp_file}.part1" "$output_file"
    rm -f "$temp_file"
    
    echo "   ✅ Reparado: $modelfile_name"
}

# Lista de modelfiles que necesitan ser reparados
MODELFILES_TO_FIX=(
    "Modelfile_Tita"
    "Modelfile_Dylan"
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
    "Modelfile_Kai"
    "Modelfile_Zara"
)

# Reparar cada modelfile
for modelfile in "${MODELFILES_TO_FIX[@]}"; do
    if [ -f "modelfiles/$modelfile" ]; then
        create_clean_modelfile "$modelfile"
    else
        echo "⚠️  Archivo no encontrado: $modelfile"
    fi
done

echo ""
echo "🎉 Reparación completada!"
echo ""
echo "📋 Modelfiles reparados:"
ls -la modelfiles/Modelfile_* | grep -v ADAN | grep -v EVA | grep -v Dany | grep -v Vito | grep -v Moderator

echo ""
echo "🔧 Para recrear los modelos:"
echo "   ./create_ollama_models.sh" 