#!/bin/bash

# Script para probar el sistema de moderación

echo "🧪 Probando sistema de moderación..."
echo ""

# URL de la API
API_URL="http://localhost:3000/api/chat"

# Función para probar un mensaje
test_message() {
    local message="$1"
    local description="$2"
    
    echo "📝 Probando: $description"
    echo "💬 Mensaje: $message"
    echo ""
    
    # Crear payload
    cat > /tmp/test_payload.json <<EOF
{
  "message": "$message",
  "chat_history": [],
  "usuario_id": "test_user"
}
EOF
    
    # Enviar petición
    curl -X POST "$API_URL" \
        -H "Content-Type: application/json" \
        -d @/tmp/test_payload.json \
        --no-buffer \
        -s | while IFS= read -r line; do
            if [[ $line == data:* ]]; then
                data="${line#data: }"
                if [[ $data != "[DONE]" ]]; then
                    echo "📤 Respuesta: $data"
                fi
            fi
        done
    
    echo ""
    echo "---"
    echo ""
}

# Casos de prueba
echo "🎯 Casos de prueba del sistema de moderación:"
echo ""

# Test 1: Mensaje general de negocio
test_message "Necesito ayuda con mi estrategia de marketing" "Consulta general de marketing"

# Test 2: Mensaje técnico
test_message "Tengo problemas con mi aplicación web" "Consulta técnica"

# Test 3: Mensaje financiero
test_message "Quiero analizar mi modelo de negocio" "Consulta financiera"

# Test 4: Mensaje con menciones explícitas
test_message "@Modelfile_Adan_CEO @sofia_mentora quiero revisar mi plan de negocio" "Menciones explícitas"

# Test 5: Mensaje de diseño
test_message "Necesito ayuda con el diseño de mi producto" "Consulta de diseño"

# Test 6: Mensaje legal
test_message "Tengo dudas sobre aspectos legales de mi empresa" "Consulta legal"

# Test 7: Mensaje de recursos humanos
test_message "Necesito ayuda con la contratación de personal" "Consulta de RRHH"

# Test 8: Mensaje de inversión
test_message "Busco inversores para mi startup" "Consulta de inversión"

echo "✅ Pruebas completadas!"
echo ""
echo "🔧 Para ejecutar las pruebas manualmente:"
echo "   curl -X POST http://localhost:3000/api/chat \\"
echo "     -H \"Content-Type: application/json\" \\"
echo "     -d '{\"message\": \"tu mensaje aquí\", \"chat_history\": [], \"usuario_id\": \"test_user\"}'" 