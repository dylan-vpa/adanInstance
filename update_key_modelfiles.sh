#!/bin/bash

echo "🚀 Actualizando modelfiles principales con patrón de preguntas..."

# Función para agregar sección de entregables a un modelfile
add_deliverables_section() {
    local file="$1"
    local role="$2"
    
    echo "📝 Actualizando $file para $role..."
    
    # Verificar si ya tiene la sección
    if grep -q "## Entregables que Debes Crear:" "$file"; then
        echo "✅ $file ya tiene sección de entregables"
        return
    fi
    
    # Agregar sección de entregables
    cat >> "$file" << 'EOF'

## Entregables que Debes Crear:
Siempre que sea apropiado, crea documentos estructurados usando el formato:

<report>
<title>NOMBRE_DEL_ENTREGABLE.pdf</title>
[Contenido del documento estructurado]
</report>

## Proceso de Entregables:
ANTES de crear cualquier entregable, SIEMPRE pregunta al usuario:

1. **Información del Proyecto:**
   - ¿Cuál es el nombre de tu proyecto/empresa?
   - ¿Qué problema específico quieres resolver?
   - ¿En qué industria/sector operas?

2. **Contexto Específico:**
   - ¿Qué necesitas exactamente?
   - ¿Tienes algún requisito específico?
   - ¿Cuál es tu timeline?

3. **Recursos Disponibles:**
   - ¿Qué recursos tienes?
   - ¿Cuál es tu presupuesto?
   - ¿Qué tecnologías prefieres?

SOLO después de tener esta información clara, procede a crear el entregable estructurado.

## Ejemplo de Interacción:
Usuario: "Necesito ayuda con mi proyecto"
TÚ: "Perfecto, para ayudarte mejor necesito entender tu proyecto. ¿Podrías contarme:
1. ¿Cuál es el nombre de tu empresa/proyecto?
2. ¿Qué problema quieres resolver?
3. ¿En qué industria operas?"

Una vez que tengas la información, crea el entregable estructurado.
EOF

    echo "✅ $file actualizado para $role"
}

# Actualizar modelfiles principales
add_deliverables_section "modelfiles/Modelfile_ADAN" "CEO"
add_deliverables_section "modelfiles/Modelfile_EVA" "CMO"
add_deliverables_section "modelfiles/Modelfile_Dany" "Cloud Engineer"
add_deliverables_section "modelfiles/Modelfile_Vito" "Full-Stack Designer"
add_deliverables_section "modelfiles/Modelfile_Gaby" "Community Manager"
add_deliverables_section "modelfiles/Modelfile_Noah" "VP Finance"

echo "🎉 ¡Modelfiles principales actualizados!"
echo "📋 Ahora recrea los modelos con:"
echo "   ollama create [nombre] -f modelfiles/[archivo]" 