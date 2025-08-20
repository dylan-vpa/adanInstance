#!/bin/bash

# Script Maestro de Setup Completo - Proyecto ADAN
# Este script orquesta todo el setup del proyecto ADAN

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

# Función para mostrar el banner del proyecto
show_banner() {
    echo ""
    echo "    ╔══════════════════════════════════════════════════════════════╗"
    echo "    ║                                                              ║"
    echo "    ║                    🚀 PROYECTO ADAN 🚀                      ║"
    echo "    ║                                                              ║"
    echo "    ║           Ecosistema EDEN - Transformando Ideas              ║"
    echo "    ║              en Startups Exitosas                            ║"
    echo "    ║                                                              ║"
    echo "    ║              Setup Completo de Desarrollo Local              ║"
    echo "    ║                                                              ║"
    echo "    ╚══════════════════════════════════════════════════════════════╝"
    echo ""
}

# Función para mostrar el menú principal
show_menu() {
    echo "🎯 Selecciona una opción:"
    echo ""
    echo "  1️⃣  🚀 Setup Completo (Recomendado)"
    echo "  2️⃣  🤖 Solo Sistema de Agentes IA"
    echo "  3️⃣  🌐 Solo Aplicación Web"
    echo "  4️⃣  🧪 Solo Pruebas del Sistema"
    echo "  5️⃣  📚 Documentación y Ayuda"
    echo "  6️⃣  🧹 Limpiar y Resetear"
    echo "  0️⃣  ❌ Salir"
    echo ""
}

# Función para setup completo
setup_complete() {
    log_header "Setup Completo del Proyecto ADAN"
    
    echo "Este setup incluye:"
    echo "  ✅ Instalación de Ollama"
    echo "  ✅ Configuración de agentes IA"
    echo "  ✅ Sistema de moderación EDEN"
    echo "  ✅ Configuración de la aplicación web"
    echo "  ✅ Pruebas del sistema"
    echo ""
    
    read -p "¿Continuar con setup completo? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup completo cancelado"
        return
    fi
    
    # Ejecutar setup de agentes IA
    log_header "Paso 1: Setup de Agentes IA"
    if [ -f "./setup_local_dev.sh" ]; then
        chmod +x ./setup_local_dev.sh
        ./setup_local_dev.sh
    else
        log_error "Script setup_local_dev.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup de agentes IA completado"
    echo ""
    
    # Ejecutar setup del flujo EDEN
    log_header "Paso 2: Setup del Flujo EDEN"
    if [ -f "./setup_eden_flow.sh" ]; then
        chmod +x ./setup_eden_flow.sh
        ./setup_eden_flow.sh
    else
        log_error "Script setup_eden_flow.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup del flujo EDEN completado"
    echo ""
    
    # Ejecutar setup de la aplicación
    log_header "Paso 3: Setup de la Aplicación Web"
    if [ -f "./setup_app_local.sh" ]; then
        chmod +x ./setup_app_local.sh
        ./setup_app_local.sh
    else
        log_error "Script setup_app_local.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup de la aplicación web completado"
    echo ""
    
    # Ejecutar pruebas del sistema
    log_header "Paso 4: Pruebas del Sistema"
    if [ -f "./test_eden_flow.sh" ]; then
        chmod +x ./test_eden_flow.sh
        ./test_eden_flow.sh
    else
        log_error "Script test_eden_flow.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup completo finalizado exitosamente"
}

# Función para setup solo de agentes IA
setup_agents_only() {
    log_header "Setup Solo de Agentes IA"
    
    echo "Este setup incluye:"
    echo "  ✅ Instalación de Ollama"
    echo "  ✅ Configuración de agentes IA"
    echo "  ✅ Sistema de moderación EDEN"
    echo ""
    
    read -p "¿Continuar con setup de agentes IA? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup de agentes IA cancelado"
        return
    fi
    
    # Ejecutar setup de agentes IA
    if [ -f "./setup_local_dev.sh" ]; then
        chmod +x ./setup_local_dev.sh
        ./setup_local_dev.sh
    else
        log_error "Script setup_local_dev.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup de agentes IA completado"
}

# Función para setup solo de la aplicación
setup_app_only() {
    log_header "Setup Solo de la Aplicación Web"
    
    echo "Este setup incluye:"
    echo "  ✅ Configuración de variables de entorno"
    echo "  ✅ Instalación de dependencias"
    echo "  ✅ Configuración de base de datos"
    echo ""
    
    read -p "¿Continuar con setup de la aplicación? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup de la aplicación cancelado"
        return
    fi
    
    # Ejecutar setup de la aplicación
    if [ -f "./setup_app_local.sh" ]; then
        chmod +x ./setup_app_local.sh
        ./setup_app_local.sh
    else
        log_error "Script setup_app_local.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Setup de la aplicación web completado"
}

# Función para ejecutar solo pruebas
run_tests_only() {
    log_header "Ejecutando Pruebas del Sistema"
    
    echo "Este paso incluye:"
    echo "  ✅ Verificación del sistema"
    echo "  ✅ Pruebas del flujo EDEN"
    echo "  ✅ Casos de uso específicos"
    echo "  ✅ Pruebas de menciones explícitas"
    echo ""
    
    read -p "¿Continuar con las pruebas? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Pruebas canceladas"
        return
    fi
    
    # Ejecutar pruebas
    if [ -f "./test_eden_flow.sh" ]; then
        chmod +x ./test_eden_flow.sh
        ./test_eden_flow.sh
    else
        log_error "Script test_eden_flow.sh no encontrado"
        return 1
    fi
    
    echo ""
    log_success "✅ Pruebas del sistema completadas"
}

# Función para mostrar documentación y ayuda
show_documentation() {
    log_header "Documentación y Ayuda"
    
    echo "📚 Recursos Disponibles:"
    echo ""
    echo "   📖 README_SETUP_LOCAL.md"
    echo "      Guía completa de setup local"
    echo ""
    echo "   🔧 Scripts de Setup:"
    echo "      - setup_local_dev.sh      # Setup de agentes IA"
    echo "      - setup_eden_flow.sh      # Setup del flujo EDEN"
    echo "      - setup_app_local.sh      # Setup de la aplicación"
    echo "      - test_eden_flow.sh       # Pruebas del sistema"
    echo ""
    echo "   🎯 Flujo EDEN:"
    echo "      - 7 niveles de desarrollo de startups"
    echo "      - 30+ agentes especializados"
    echo "      - Sistema de moderación inteligente"
    echo ""
    echo "   🌐 Aplicación Web:"
    echo "      - Next.js 15 + React 19"
    echo "      - Supabase para backend"
    echo "      - Sistema de chat inteligente"
    echo ""
    echo "🔗 Enlaces Útiles:"
    echo "   - Ollama: https://ollama.ai/docs"
    echo "   - Next.js: https://nextjs.org/docs"
    echo "   - Supabase: https://supabase.com/docs"
    echo ""
    echo "📞 Para Soporte:"
    echo "   - Revisa la documentación del proyecto"
    echo "   - Ejecuta las pruebas del sistema"
    echo "   - Contacta al equipo de desarrollo"
}

# Función para limpiar y resetear
clean_and_reset() {
    log_header "Limpieza y Reset del Sistema"
    
    echo "⚠️  ADVERTENCIA: Esta acción eliminará todos los modelos de Ollama"
    echo "   y reseteará la configuración del proyecto."
    echo ""
    
    read -p "¿Estás seguro de que quieres continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Limpieza cancelada"
        return
    fi
    
    read -p "¿Confirmar limpieza completa? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Limpieza cancelada"
        return
    fi
    
    log_step "Limpiando modelos de Ollama..."
    
    # Listar y eliminar modelos del proyecto
    local project_models=$(ollama list | grep -E "(Modelfile_|eva_|tita_|dany_|ethan_|vito_|ema_|sofia_|goga_|andu_|luna_|liam_|diego_|milo_|zoe_|elsy_|bella_|max_|kai_|ray_|sam_|leo_|alex_|mia_|nia_|tom_|ana_|ben_|zara_|oliver_|sofia_success|jack_|maya_)" | awk '{print $1}' || echo "")
    
    if [ -n "$project_models" ]; then
        echo "Modelos a eliminar:"
        echo "$project_models"
        echo ""
        
        for model in $project_models; do
            log_info "Eliminando modelo: $model"
            ollama rm "$model" 2>/dev/null || true
        done
        
        log_success "Modelos del proyecto eliminados"
    else
        log_info "No se encontraron modelos del proyecto para eliminar"
    fi
    
    # Limpiar archivos temporales
    log_step "Limpiando archivos temporales..."
    rm -f /tmp/eden_test_*.json /tmp/use_case_*.json /tmp/mention_test_*.json /tmp/basic_test.json
    
    # Limpiar archivos de configuración local
    log_step "Limpiando configuración local..."
    rm -f .env.local
    rm -f ../app/.env.local
    
    log_success "✅ Limpieza y reset completados"
    echo ""
    echo "🔄 Para restaurar el sistema:"
    echo "   1. Ejecuta este script nuevamente"
    echo "   2. Selecciona 'Setup Completo'"
    echo "   3. Sigue las instrucciones paso a paso"
}

# Función para mostrar estado del sistema
show_system_status() {
    log_header "Estado del Sistema"
    
    echo "🔍 Verificando estado del proyecto ADAN..."
    echo ""
    
    # Verificar Ollama
    log_step "Verificando Ollama..."
    if command -v ollama >/dev/null 2>&1; then
        log_success "✅ Ollama instalado"
        
        if ollama list >/dev/null 2>&1; then
            log_success "✅ Ollama ejecutándose"
            
            # Contar modelos del proyecto
            local project_models_count=$(ollama list | grep -c -E "(Modelfile_|eva_|tita_|dany_|ethan_|vito_|ema_|sofia_|goga_|andu_|luna_|liam_|diego_|milo_|zoe_|elsy_|bella_|max_|kai_|ray_|sam_|leo_|alex_|mia_|nia_|tom_|ana_|ben_|zara_|oliver_|sofia_success|jack_|maya_)" || echo "0")
            echo "   📊 Modelos del proyecto: $project_models_count"
        else
            log_warning "⚠️  Ollama no responde"
        fi
    else
        log_error "❌ Ollama no instalado"
    fi
    
    echo ""
    
    # Verificar aplicación
    log_step "Verificando aplicación web..."
    if [ -d "../app" ]; then
        log_success "✅ Directorio de aplicación encontrado"
        
        if [ -f "../app/.env.local" ]; then
            log_success "✅ Variables de entorno configuradas"
        else
            log_warning "⚠️  Variables de entorno no configuradas"
        fi
        
        if [ -d "../app/node_modules" ]; then
            log_success "✅ Dependencias instaladas"
        else
            log_warning "⚠️  Dependencias no instaladas"
        fi
    else
        log_error "❌ Directorio de aplicación no encontrado"
    fi
    
    echo ""
    
    # Verificar scripts
    log_step "Verificando scripts de setup..."
    local scripts=("setup_local_dev.sh" "setup_eden_flow.sh" "setup_app_local.sh" "test_eden_flow.sh")
    local scripts_available=0
    
    for script in "${scripts[@]}"; do
        if [ -f "$script" ]; then
            if [ -x "$script" ]; then
                log_success "✅ $script (ejecutable)"
                scripts_available=$((scripts_available + 1))
            else
                log_warning "⚠️  $script (no ejecutable)"
            fi
        else
            log_error "❌ $script (no encontrado)"
        fi
    done
    
    echo ""
    echo "📈 Estado General:"
    if [ $scripts_available -eq ${#scripts[@]} ]; then
        log_success "🎉 Sistema completamente configurado"
    elif [ $scripts_available -gt 0 ]; then
        log_warning "⚠️  Sistema parcialmente configurado"
    else
        log_error "❌ Sistema no configurado"
    fi
}

# Función principal
main() {
    show_banner
    
    while true; do
        show_menu
        read -p "Selecciona una opción (0-6): " choice
        
        case $choice in
            1)
                setup_complete
                ;;
            2)
                setup_agents_only
                ;;
            3)
                setup_app_only
                ;;
            4)
                run_tests_only
                ;;
            5)
                show_documentation
                ;;
            6)
                clean_and_reset
                ;;
            0)
                log_info "¡Hasta luego! 🚀"
                exit 0
                ;;
            *)
                log_error "Opción inválida. Por favor selecciona 0-6."
                ;;
        esac
        
        echo ""
        read -p "Presiona Enter para continuar..."
        echo ""
    done
}

# Ejecutar función principal
main "$@" 