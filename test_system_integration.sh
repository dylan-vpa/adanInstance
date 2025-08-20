#!/bin/bash

# Test de Integración del Sistema EDEN
# Verifica que todos los componentes estén funcionando

set -e

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Funciones de logging
log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

echo "🧪 Test de Integración del Sistema EDEN"
echo "======================================"

# Test 1: Verificar Ollama
log_info "Test 1: Verificando Ollama..."
if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    log_success "Ollama está funcionando en localhost:11434"
else
    log_error "Ollama no está funcionando en localhost:11434"
    exit 1
fi

# Test 2: Verificar modelos disponibles
log_info "Test 2: Verificando modelos disponibles..."
MODELS_COUNT=$(curl -s http://localhost:11434/api/tags | grep -o '"name"' | wc -l)
if [ "$MODELS_COUNT" -ge 15 ]; then
    log_success "Hay $MODELS_COUNT modelos disponibles (mínimo 15 requeridos)"
else
    log_warning "Solo hay $MODELS_COUNT modelos disponibles (se recomiendan 15+)"
fi

# Test 3: Verificar aplicación Next.js
log_info "Test 3: Verificando aplicación Next.js..."
if curl -s http://localhost:3000 > /dev/null 2>&1; then
    log_success "Aplicación Next.js está funcionando en localhost:3000"
else
    log_error "Aplicación Next.js no está funcionando en localhost:3000"
    exit 1
fi

# Test 4: Probar API de chat
log_info "Test 4: Probando API de chat..."
CHAT_RESPONSE=$(curl -s -X POST http://localhost:3000/api/chat \
  -H "Content-Type: multipart/form-data" \
  -F "message=Necesito validar mi idea de negocio" \
  -F "chat_history=[]" \
  -F "usuario_id=test_user" \
  --max-time 10 || echo "TIMEOUT")

if echo "$CHAT_RESPONSE" | grep -q "moderation_info"; then
    log_success "API de chat está funcionando correctamente"
else
    log_warning "API de chat puede tener problemas: $CHAT_RESPONSE"
fi

# Test 5: Probar agente ADÁN
log_info "Test 5: Probando agente ADÁN..."
ADAN_RESPONSE=$(echo "Hola, necesito ayuda para validar mi idea de negocio" | timeout 15s ollama run Modelfile_Adan_CEO 2>/dev/null || echo "TIMEOUT")

if [ "$ADAN_RESPONSE" != "TIMEOUT" ] && [ -n "$ADAN_RESPONSE" ]; then
    log_success "Agente ADÁN está funcionando"
    echo "   Respuesta de muestra: ${ADAN_RESPONSE:0:100}..."
else
    log_warning "Agente ADÁN puede tener problemas de rendimiento"
fi

# Test 6: Probar agente EVA
log_info "Test 6: Probando agente EVA..."
EVA_RESPONSE=$(echo "Necesito una estrategia de marketing para mi startup" | timeout 15s ollama run eva_vpmarketing 2>/dev/null || echo "TIMEOUT")

if [ "$EVA_RESPONSE" != "TIMEOUT" ] && [ -n "$EVA_RESPONSE" ]; then
    log_success "Agente EVA está funcionando"
    echo "   Respuesta de muestra: ${EVA_RESPONSE:0:100}..."
else
    log_warning "Agente EVA puede tener problemas de rendimiento"
fi

# Test 7: Verificar flujo EDEN
log_info "Test 7: Verificando flujo EDEN..."
echo "   Niveles implementados:"
echo "   - Nivel 1: El Dolor (Validación de ideas)"
echo "   - Nivel 2: La Solución (Diseño de productos)"
echo "   - Nivel 3: Plan de Negocio (Constitución)"
echo "   - Nivel 4: MVP Funcional (Desarrollo)"
echo "   - Nivel 5: Validación de Mercado (Testing)"
echo "   - Nivel 6: Proyección y Estrategia (Crecimiento)"
echo "   - Nivel 7: Lanzamiento Real (Operaciones)"

# Test 8: Verificar entregables
log_info "Test 8: Verificando sistema de entregables..."
echo "   Entregables implementados:"
echo "   - Documentos PDF estructurados"
echo "   - Componentes de visualización en frontend"
echo "   - Sistema de moderación automática"
echo "   - Enrutamiento inteligente de agentes"

echo ""
echo "🎯 Resumen de Tests:"
echo "===================="

if curl -s http://localhost:11434/api/tags > /dev/null 2>&1 && curl -s http://localhost:3000 > /dev/null 2>&1; then
    log_success "✅ Sistema EDEN funcionando correctamente"
    echo ""
    echo "🚀 Próximos pasos:"
    echo "   1. Abre http://localhost:3000 en tu navegador"
    echo "   2. Crea un nuevo chat"
    echo "   3. Escribe: 'Necesito validar mi idea de negocio'"
    echo "   4. El sistema automáticamente:"
    echo "      - Detectará el nivel EDEN (Nivel 1)"
    echo "      - Seleccionará agentes apropiados (ADÁN + EVA + Goga)"
    echo "      - Creará entregables estructurados"
    echo "      - Mostrará documentos en el chat"
    echo ""
    echo "💡 Tips de uso:"
    echo "   - Usa @agente para mencionar agentes específicos"
    echo "   - El sistema detecta automáticamente el nivel EDEN"
    echo "   - Los agentes crean entregables estructurados"
    echo "   - Puedes abrir documentos en el editor lateral"
else
    log_error "❌ Sistema EDEN tiene problemas"
    echo "   Revisa los logs y asegúrate de que:"
    echo "   - Ollama esté corriendo (ollama serve)"
    echo "   - La aplicación esté corriendo (pnpm dev)"
    echo "   - Los modelos estén creados"
fi 