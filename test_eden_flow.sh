#!/bin/bash

# Script de Prueba para el Flujo EDEN - Proyecto ADAN
# Este script prueba el sistema de moderación y enrutamiento del flujo EDEN

set -e  # Exit on any error

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Función para logging
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_step() {
    echo -e "${PURPLE}🔧 $1${NC}"
}

log_header() {
    echo -e "${CYAN}🎯 $1${NC}"
    echo "=================================="
}

log_test() {
    echo -e "${GREEN}🧪 $1${NC}"
}

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para verificar Ollama
check_ollama() {
    if ! command_exists ollama; then
        log_error "Ollama no está instalado"
        return 1
    fi
    
    if ! ollama list >/dev/null 2>&1; then
        log_warning "Ollama no está ejecutándose. Iniciando servicio..."
        ollama serve &
        sleep 5
    fi
    
    return 0
}

# Función para probar un caso del flujo EDEN
test_eden_case() {
    local level=$1
    local description=$2
    local message=$3
    local expected_agents=$4
    
    log_test "Probando Nivel $level: $description"
    echo "💬 Mensaje: $message"
    echo "🎯 Agentes esperados: $expected_agents"
    echo ""
    
    # Crear archivo temporal para la consulta
    local temp_file="/tmp/eden_test_${level}.json"
    cat > "$temp_file" << EOF
{
  "model": "Modelfile_Moderator",
  "messages": [
    {
      "role": "user",
      "content": "$message"
    }
  ],
  "stream": false,
  "temperature": 0.3
}
EOF
    
    # Ejecutar consulta al moderador
    log_info "Consultando moderador..."
    local response=$(ollama run Modelfile_Moderator < "$temp_file 2>/dev/null" || echo "Error en consulta")
    
    # Limpiar archivo temporal
    rm -f "$temp_file"
    
    # Analizar respuesta
    echo "🤖 Respuesta del moderador:"
    echo "$response"
    echo ""
    
    # Verificar si la respuesta contiene JSON válido
    if echo "$response" | grep -q "eden_level"; then
        log_success "✅ Moderador respondió correctamente"
        
        # Extraer nivel EDEN
        local detected_level=$(echo "$response" | grep -o '"eden_level":"[^"]*"' | cut -d'"' -f4)
        if [ -n "$detected_level" ]; then
            log_info "📊 Nivel EDEN detectado: $detected_level"
        fi
        
        # Extraer agentes sugeridos
        local suggested_agents=$(echo "$response" | grep -o '"agents":\[[^]]*\]' | grep -o '"[^"]*"' | tr '\n' ' ')
        if [ -n "$suggested_agents" ]; then
            log_info "👥 Agentes sugeridos: $suggested_agents"
        fi
    else
        log_warning "⚠️  Respuesta del moderador no contiene formato esperado"
    fi
    
    echo "---"
    echo ""
}

# Función para probar casos específicos del flujo EDEN
test_eden_cases() {
    log_header "Pruebas del Flujo EDEN"
    
    local test_cases=(
        "1|El Dolor|Necesito validar científicamente que mi idea de negocio resuelve un problema real, urgente y monetizable|ADÁN,EVA,Gaby,Max,Kai"
        "2|La Solución|Quiero diseñar una solución única y diferenciada para mi mercado|ADÁN,Isa,Ema,Ray,Bella,Kai"
        "3|Plan de Negocio|Necesito crear mi plan de negocio y constituir legalmente mi empresa|ADÁN,Elsy,Bella,Milo,Tita,Zoe,Noah,Sam,Leo"
        "4|MVP Funcional|Quiero desarrollar un MVP funcional que valide mis hipótesis|ADÁN,Dylan,Isa,Dany,Ethan,Julia,Alex,Mia,Kai"
        "5|Validación de Mercado|Necesito validar mi producto en el mercado real y optimizarlo|ADÁN,Gaby,Mentores,Mila,Max,Ema,Nia,Tom,Ana"
        "6|Proyección y Estrategia|Busco definir mi estrategia de crecimiento y captar inversión|ADÁN,Noah,Liam,Diego,Luna,Ben,Zara,Oliver"
        "7|Lanzamiento Real|Estoy listo para lanzar mi startup al mercado|ADÁN,Gaby,EVA,Bella,Mila,Ray,Sofia,Jack,Maya"
    )
    
    for test_case in "${test_cases[@]}"; do
        IFS='|' read -r level description message expected_agents <<< "$test_case"
        test_eden_case "$level" "$description" "$message" "$expected_agents"
    done
}

# Función para probar casos de uso específicos
test_specific_use_cases() {
    log_header "Casos de Uso Específicos"
    
    local specific_cases=(
        "Validación de Idea|Tengo una idea para una app de delivery de comida saludable, ¿cómo valido si hay mercado?"
        "Diseño de Solución|Mi competencia ya existe, ¿cómo puedo diferenciarme y crear una propuesta única?"
        "Constitución Legal|¿Qué estructura legal es mejor para mi startup y cómo la constituyo?"
        "Desarrollo MVP|¿Cuáles son las features mínimas que debe tener mi MVP para validar mi idea?"
        "Validación de Mercado|¿Cómo puedo medir si mi producto está funcionando en el mercado?"
        "Búsqueda de Inversión|¿Qué necesito preparar para buscar inversión y cómo valúo mi startup?"
        "Lanzamiento|¿Cuál es la mejor estrategia para lanzar mi startup y generar tracción inicial?"
    )
    
    for use_case in "${specific_cases[@]}"; do
        IFS='|' read -r title message <<< "$use_case"
        log_test "Caso: $title"
        echo "💬 Mensaje: $message"
        echo ""
        
        # Crear archivo temporal
        local temp_file="/tmp/use_case_$(echo "$title" | tr ' ' '_').json"
        cat > "$temp_file" << EOF
{
  "model": "Modelfile_Moderator",
  "messages": [
    {
      "role": "user",
      "content": "$message"
    }
  ],
  "stream": false,
  "temperature": 0.3
}
EOF
        
        # Ejecutar consulta
        log_info "Consultando moderador..."
        local response=$(ollama run Modelfile_Moderator < "$temp_file 2>/dev/null" || echo "Error en consulta")
        
        # Limpiar
        rm -f "$temp_file"
        
        # Mostrar respuesta resumida
        echo "🤖 Respuesta del moderador:"
        echo "$response" | head -10
        if [ $(echo "$response" | wc -l) -gt 10 ]; then
            echo "... (respuesta truncada)"
        fi
        echo ""
        echo "---"
        echo ""
    done
}

# Función para probar enrutamiento con menciones explícitas
test_explicit_mentions() {
    log_header "Pruebas de Menciones Explícitas"
    
    local mention_cases=(
        "@Modelfile_Adan_CEO @sofia_mentora|Consulta directa al CEO y mentora financiera|ADÁN,Sofia"
        "@eva_vpmarketing @bella_branding|Consulta de marketing y branding|EVA,Bella"
        "@dany_tecnicocloud @ray_tech_architect|Consulta técnica y de arquitectura|Dany,Ray"
        "@noah_finance @luna_inversionista|Consulta financiera e inversión|Noah,Luna"
    )
    
    for mention_case in "${mention_cases[@]}"; do
        IFS='|' read -r mention description expected <<< "$mention_case"
        log_test "Menciones: $mention"
        echo "💬 Descripción: $description"
        echo "🎯 Esperado: $expected"
        echo ""
        
        # Crear mensaje con menciones
        local message="Hola $mention, $description"
        
        # Crear archivo temporal
        local temp_file="/tmp/mention_test_$(echo "$mention" | tr '@' '_').json"
        cat > "$temp_file" << EOF
{
  "model": "Modelfile_Moderator",
  "messages": [
    {
      "role": "user",
      "content": "$message"
    }
  ],
  "stream": false,
  "temperature": 0.3
}
EOF
        
        # Ejecutar consulta
        log_info "Consultando moderador..."
        local response=$(ollama run Modelfile_Moderator < "$temp_file 2>/dev/null" || echo "Error en consulta")
        
        # Limpiar
        rm -f "$temp_file"
        
        # Verificar si incluye los agentes mencionados
        local includes_mentioned=true
        for agent in $(echo "$mention" | tr '@' ' '); do
            if ! echo "$response" | grep -q "$agent"; then
                includes_mentioned=false
                break
            fi
        done
        
        if [ "$includes_mentioned" = true ]; then
            log_success "✅ Moderador incluyó agentes mencionados"
        else
            log_warning "⚠️  Moderador no incluyó todos los agentes mencionados"
        fi
        
        echo "---"
        echo ""
    done
}

# Función para probar el sistema completo
test_complete_system() {
    log_header "Prueba del Sistema Completo"
    
    log_step "Verificando modelos disponibles..."
    local available_models=$(ollama list | grep -c "Modelfile_" || echo "0")
    log_info "Modelos disponibles: $available_models"
    
    log_step "Verificando moderador..."
    if ollama list | grep -q "Modelfile_Moderator"; then
        log_success "✅ Moderador disponible"
    else
        log_error "❌ Moderador no disponible"
        return 1
    fi
    
    log_step "Verificando agente principal..."
    if ollama list | grep -q "Modelfile_Adan_CEO"; then
        log_success "✅ ADÁN CEO disponible"
    else
        log_error "❌ ADÁN CEO no disponible"
        return 1
    fi
    
    log_step "Probando comunicación básica..."
    local test_message="Hola, soy un emprendedor con una idea de negocio"
    local temp_file="/tmp/basic_test.json"
    
    cat > "$temp_file" << EOF
{
  "model": "Modelfile_Moderator",
  "messages": [
    {
      "role": "user",
      "content": "$test_message"
    }
  ],
  "stream": false,
  "temperature": 0.3
}
EOF
    
    local response=$(ollama run Modelfile_Moderator < "$temp_file 2>/dev/null" || echo "Error en consulta")
    rm -f "$temp_file"
    
    if echo "$response" | grep -q "eden_level"; then
        log_success "✅ Sistema respondiendo correctamente"
    else
        log_warning "⚠️  Sistema no responde en formato esperado"
    fi
}

# Función para mostrar resumen de pruebas
show_test_summary() {
    log_header "Resumen de Pruebas"
    
    echo "🎯 Pruebas del Flujo EDEN completadas"
    echo ""
    echo "📊 Estado del Sistema:"
    
    # Verificar modelos clave
    local key_models=("Modelfile_Moderator" "Modelfile_Adan_CEO" "eva_vpmarketing" "sofia_mentora")
    local available_count=0
    
    for model in "${key_models[@]}"; do
        if ollama list | grep -q "$model"; then
            echo "   ✅ $model"
            available_count=$((available_count + 1))
        else
            echo "   ❌ $model"
        fi
    done
    
    echo ""
    echo "📈 Disponibilidad: $available_count/${#key_models[@]} modelos clave"
    
    if [ $available_count -eq ${#key_models[@]} ]; then
        log_success "🎉 Sistema completamente funcional"
    elif [ $available_count -gt 0 ]; then
        log_warning "⚠️  Sistema parcialmente funcional"
    else
        log_error "❌ Sistema no funcional"
    fi
    
    echo ""
    echo "🔧 Próximos pasos:"
    echo "   1. Si hay modelos faltantes, ejecuta: ./create_ollama_models.sh"
    echo "   2. Para probar un agente específico: ollama run [nombre_modelo]"
    echo "   3. Para probar el moderador: ollama run Modelfile_Moderator"
    echo "   4. Para iniciar la app: cd ../app && pnpm dev"
}

# Función principal
main() {
    log_header "Pruebas del Flujo EDEN - Proyecto ADAN"
    
    echo "Este script probará el sistema de moderación y enrutamiento"
    echo "del flujo EDEN con casos de uso reales."
    echo ""
    
    # Verificar Ollama
    if ! check_ollama; then
        log_error "Ollama no está disponible. Ejecuta primero ./setup_local_dev.sh"
        exit 1
    fi
    
    # Ejecutar pruebas
    test_complete_system
    echo ""
    
    test_eden_cases
    echo ""
    
    test_specific_use_cases
    echo ""
    
    test_explicit_mentions
    echo ""
    
    # Mostrar resumen
    show_test_summary
}

# Ejecutar función principal
main "$@" 