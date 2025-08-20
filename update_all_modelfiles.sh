#!/bin/bash

echo "🚀 Actualizando TODOS los modelfiles con patrón de preguntas y entregables..."

# Función para actualizar un modelfile
update_modelfile() {
    local file="$1"
    local role=$(echo "$file" | sed 's/Modelfile_//' | sed 's/\.//')
    
    echo "📝 Actualizando $file..."
    
    # Crear backup
    cp "$file" "${file}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Agregar sección de entregables y proceso de preguntas
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

2. **Contexto Técnico:**
   - ¿Qué funcionalidades necesitas específicamente?
   - ¿Tienes algún diseño o mockup?
   - ¿Cuál es tu timeline de desarrollo?

3. **Recursos Disponibles:**
   - ¿Qué tecnologías prefieres usar?
   - ¿Tienes algún desarrollador en tu equipo?
   - ¿Cuál es tu presupuesto aproximado?

4. **Objetivos Específicos:**
   - ¿Qué quieres lograr exactamente?
   - ¿Es para validar una idea o ya tienes usuarios?
   - ¿Qué métricas de éxito buscas?

SOLO después de tener esta información clara, procede a crear el entregable estructurado.

## Ejemplo de Interacción:
Usuario: "Necesito un MVP web"
TÚ: "Perfecto, para crear tu MVP web necesito entender mejor tu proyecto. ¿Podrías contarme:
1. ¿Cuál es el nombre de tu empresa/proyecto?
2. ¿Qué problema resuelves?
3. ¿Qué funcionalidades principales necesitas?
4. ¿Tienes algún diseño o idea visual?"

Una vez que tengas la información, crea el entregable estructurado.
EOF

    echo "✅ $file actualizado"
}

# Actualizar todos los modelfiles principales
for file in modelfiles/Modelfile_*; do
    if [[ -f "$file" && ! "$file" =~ \.backup\. ]]; then
        update_modelfile "$file"
    fi
done

echo "🎉 ¡Todos los modelfiles han sido actualizados!"
echo "📋 Ahora necesitas recrear los modelos con:"
echo "   ollama create [nombre] -f modelfiles/[archivo]" 