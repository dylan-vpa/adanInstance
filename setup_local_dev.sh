#!/bin/bash

# Script de Setup para Desarrollo Local - Proyecto ADAN
# Este script configura todo el entorno necesario para desarrollo local

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

# Función para verificar si un comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Función para detectar el sistema operativo
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        echo "linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "macos"
    elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
        echo "windows"
    else
        echo "unknown"
    fi
}

# Función para instalar Ollama
install_ollama() {
    local os=$(detect_os)
    
    log_step "Instalando Ollama para $os..."
    
    if [[ "$os" == "linux" ]]; then
        if command_exists curl; then
            curl -fsSL https://ollama.ai/install.sh | sh
        else
            log_error "curl no está instalado. Por favor instala curl primero."
            exit 1
        fi
    elif [[ "$os" == "macos" ]]; then
        if command_exists brew; then
            brew install ollama
        else
            log_error "Homebrew no está instalado. Por favor instala Homebrew primero."
            exit 1
        fi
    elif [[ "$os" == "windows" ]]; then
        log_warning "Para Windows, por favor descarga Ollama desde: https://ollama.ai/download"
        log_warning "Ejecuta este script después de instalar Ollama manualmente."
        exit 1
    else
        log_error "Sistema operativo no soportado: $os"
        exit 1
    fi
    
    log_success "Ollama instalado correctamente"
}

# Función para verificar Ollama
check_ollama() {
    log_step "Verificando instalación de Ollama..."
    
    if ! command_exists ollama; then
        log_error "Ollama no está instalado o no está en el PATH"
        return 1
    fi
    
    # Verificar que Ollama esté ejecutándose
    if ! ollama list >/dev/null 2>&1; then
        log_warning "Ollama no está ejecutándose. Iniciando servicio..."
        ollama serve &
        sleep 5
    fi
    
    log_success "Ollama está funcionando correctamente"
    return 0
}

# Función para descargar modelo base
download_base_model() {
    log_step "Descargando modelo base deepseek-r1..."
    
    if ollama list | grep -q "deepseek-r1"; then
        log_info "Modelo base deepseek-r1 ya está disponible"
        return 0
    fi
    
    log_info "Descargando modelo base (esto puede tomar varios minutos)..."
    if ollama pull deepseek-r1; then
        log_success "Modelo base descargado correctamente"
    else
        log_error "Error al descargar el modelo base"
        return 1
    fi
}

# Función para generar modelfiles limpios
generate_clean_modelfiles() {
    log_step "Generando modelfiles limpios..."
    
    if [ -f "./generate_clean_modelfiles.sh" ]; then
        chmod +x ./generate_clean_modelfiles.sh
        if ./generate_clean_modelfiles.sh; then
            log_success "Modelfiles limpios generados correctamente"
        else
            log_error "Error al generar modelfiles limpios"
            return 1
        fi
    else
        log_warning "Script generate_clean_modelfiles.sh no encontrado"
        return 1
    fi
}

# Función para crear modelos en Ollama
create_ollama_models() {
    log_step "Creando modelos en Ollama..."
    
    if [ -f "./create_ollama_models.sh" ]; then
        chmod +x ./create_ollama_models.sh
        if ./create_ollama_models.sh; then
            log_success "Modelos de Ollama creados correctamente"
        else
            log_error "Error al crear modelos de Ollama"
            return 1
        fi
    else
        log_warning "Script create_ollama_models.sh no encontrado"
        return 1
    fi
}

# Función para verificar modelos creados
verify_models() {
    log_step "Verificando modelos creados..."
    
    local expected_models=(
        "Modelfile_Adan_CEO"
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
    
    local missing_models=()
    
    for model in "${expected_models[@]}"; do
        if ollama list | grep -q "^$model"; then
            log_success "✅ $model"
        else
            log_warning "❌ $model (faltante)"
            missing_models+=("$model")
        fi
    done
    
    if [ ${#missing_models[@]} -eq 0 ]; then
        log_success "Todos los modelos están disponibles"
        return 0
    else
        log_warning "${#missing_models[@]} modelos faltantes: ${missing_models[*]}"
        return 1
    fi
}

# Función para configurar variables de entorno
setup_environment() {
    log_step "Configurando variables de entorno..."
    
    local env_file=".env.local"
    
    if [ ! -f "$env_file" ]; then
        log_info "Creando archivo .env.local..."
        cat > "$env_file" << EOF
# Configuración local para desarrollo
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key_here
PAYPAL_CLIENT_ID=your_paypal_client_id_here
PAYPAL_CLIENT_SECRET=your_paypal_client_secret_here

# URL de Ollama local
OLLAMA_BASE_URL=http://localhost:11434/v1/chat/completions

# Configuración de desarrollo
NODE_ENV=development
NEXT_PUBLIC_APP_ENV=development
EOF
        log_success "Archivo .env.local creado"
        log_warning "Por favor configura las variables de entorno en $env_file"
    else
        log_info "Archivo .env.local ya existe"
    fi
}

# Función para instalar dependencias de la app
install_app_dependencies() {
    log_step "Instalando dependencias de la aplicación..."
    
    if [ -d "../app" ]; then
        cd "../app"
        
        if command_exists pnpm; then
            log_info "Instalando dependencias con pnpm..."
            pnpm install
        elif command_exists npm; then
            log_info "Instalando dependencias con npm..."
            npm install
        elif command_exists yarn; then
            log_info "Instalando dependencias con yarn..."
            yarn install
        else
            log_error "No se encontró ningún gestor de paquetes (pnpm, npm, yarn)"
            return 1
        fi
        
        cd "../adanInstance"
        log_success "Dependencias de la aplicación instaladas"
    else
        log_warning "Directorio ../app no encontrado"
    fi
}

# Función para probar el sistema
test_system() {
    log_step "Probando el sistema..."
    
    if [ -f "./test_moderation.sh" ]; then
        chmod +x ./test_moderation.sh
        log_info "Ejecutando pruebas del sistema..."
        if ./test_moderation.sh; then
            log_success "Pruebas del sistema completadas exitosamente"
        else
            log_warning "Algunas pruebas fallaron"
        fi
    else
        log_warning "Script de pruebas no encontrado"
    fi
}

# Función para mostrar información de uso
show_usage_info() {
    log_header "Información de Uso"
    
    echo ""
    echo "🚀 Para iniciar la aplicación:"
    echo "   cd ../app"
    echo "   pnpm dev"
    echo ""
    echo "🤖 Para probar los agentes:"
    echo "   ollama run Modelfile_Adan_CEO"
    echo "   ollama run eva_vpmarketing"
    echo ""
    echo "🧪 Para ejecutar pruebas:"
    echo "   ./test_moderation.sh"
    echo ""
    echo "📚 Documentación:"
    echo "   - Ollama: https://ollama.ai/docs"
    echo "   - Next.js: https://nextjs.org/docs"
    echo ""
    echo "🔧 Comandos útiles:"
    echo "   ollama list                    # Listar modelos"
    echo "   ollama rm [modelo]             # Eliminar modelo"
    echo "   ollama pull [modelo]           # Descargar modelo"
    echo "   ollama serve                   # Iniciar servidor"
    echo ""
}

# Función principal
main() {
    log_header "Setup de Desarrollo Local - Proyecto ADAN"
    
    echo "Este script configurará todo el entorno necesario para desarrollo local."
    echo "Incluye:"
    echo "  - Instalación de Ollama"
    echo "  - Descarga de modelos base"
    echo "  - Generación de modelfiles"
    echo "  - Creación de agentes especializados"
    echo "  - Configuración del entorno"
    echo ""
    
    read -p "¿Continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelado"
        exit 0
    fi
    
    # Verificar requisitos del sistema
    log_header "Verificando requisitos del sistema"
    
    if ! command_exists curl && ! command_exists wget; then
        log_error "Se requiere curl o wget para continuar"
        exit 1
    fi
    
    # Instalar Ollama si es necesario
    if ! check_ollama; then
        log_header "Instalando Ollama"
        install_ollama
        check_ollama
    fi
    
    # Descargar modelo base
    log_header "Configurando modelos base"
    download_base_model
    
    # Generar modelfiles
    log_header "Generando modelfiles"
    generate_clean_modelfiles
    
    # Crear modelos en Ollama
    log_header "Creando modelos en Ollama"
    create_ollama_models
    
    # Verificar modelos
    log_header "Verificando modelos"
    verify_models
    
    # Configurar entorno
    log_header "Configurando entorno"
    setup_environment
    
    # Instalar dependencias de la app
    log_header "Instalando dependencias"
    install_app_dependencies
    
    # Probar sistema
    log_header "Probando sistema"
    test_system
    
    # Mostrar información de uso
    show_usage_info
    
    log_header "Setup Completado"
    log_success "¡El entorno de desarrollo local está listo!"
    echo ""
    echo "🎉 Próximos pasos:"
    echo "   1. Configura las variables de entorno en .env.local"
    echo "   2. Inicia la aplicación con 'cd ../app && pnpm dev'"
    echo "   3. Prueba los agentes con 'ollama run [nombre_agente]'"
    echo ""
    echo "📖 Para más información, consulta la documentación del proyecto."
}

# Ejecutar función principal
main "$@" 