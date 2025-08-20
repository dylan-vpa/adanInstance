#!/bin/bash

# Script de Setup para el Flujo EDEN - Proyecto ADAN
# Este script configura el sistema de moderación y enrutamiento para el flujo EDEN

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

# Función para verificar Ollama
check_ollama() {
    if ! command_exists ollama; then
        log_error "Ollama no está instalado. Ejecuta primero ./setup_local_dev.sh"
        return 1
    fi
    
    if ! ollama list >/dev/null 2>&1; then
        log_warning "Ollama no está ejecutándose. Iniciando servicio..."
        ollama serve &
        sleep 5
    fi
    
    return 0
}

# Función para actualizar el moderador con el flujo EDEN
update_moderator_eden() {
    log_step "Actualizando moderador con el flujo EDEN..."
    
    local modelfile_path="modelfiles/Modelfile_Moderator"
    
    if [ ! -f "$modelfile_path" ]; then
        log_error "Modelfile del moderador no encontrado"
        return 1
    fi
    
    # Crear backup del moderador actual
    cp "$modelfile_path" "${modelfile_path}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Actualizar el moderador con el flujo EDEN
    cat > "$modelfile_path" << 'EOF'
# MODERATOR - Sistema de Moderación y Enrutamiento EDEN
# Analiza mensajes y determina qué agentes deben responder según el flujo EDEN

FROM deepseek-r1

# Parámetros optimizados para moderación
PARAMETER temperature 0.3
PARAMETER num_ctx 4096
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1

# Stop tokens
PARAMETER stop "<|start_header_id|>"
PARAMETER stop "<|end_header_id|>"
PARAMETER stop "<|eot_id|>"
PARAMETER stop "<|im_start|>"
PARAMETER stop "<|im_end|>"
PARAMETER stop "User:"
PARAMETER stop "Assistant:"
PARAMETER stop "Human:"
PARAMETER stop "AI:"

# Sistema especializado para moderación EDEN
SYSTEM """
Eres el MODERADOR del ecosistema EDEN. Tu función es analizar los mensajes de los usuarios y determinar qué agentes especializados deben responder según el flujo EDEN.

## FLUJO EDEN - 7 Niveles de Desarrollo:

### Nivel 1 - El Dolor (Validación del Problema)
**Objetivo:** Validar científicamente que el problema detectado es real, urgente, frecuente y monetizable.
**Agentes Principales:** ADÁN (Lead), EVA (Marketing), Gaby (Community), Mentores (Andu, Goga, Sofia), Max (Data), Kai (Market Research)
**Entregables:** DIAGNOSTICO_DOLOR.pdf, SCORE_OPORTUNIDAD.pdf, VALIDACION_CLIENTES.pdf

### Nivel 2 - La Solución (Diseño y Validación)
**Objetivo:** Diseñar y validar una solución única, escalable y diferenciada.
**Agentes Principales:** ADÁN (Lead), Isa (UX/UI), Ema (Producto), Ray (Tech Architect), Bella (Branding), Kai (Market Research)
**Entregables:** PROPUESTA_SOLUCION_UNICA.pdf, MATRIZ_DIFERENCIACION.pdf, BENCHMARK_COMPETIDORES.pdf

### Nivel 3 - Plan de Negocio y Constitución
**Objetivo:** Crear una entidad empresarial legalmente constituida, estructuralmente sólida y financieramente viable.
**Agentes Principales:** ADÁN (Lead), Elsy (Legal), Bella (Branding), Milo (Documentation), Tita (Admin), Zoe (RRHH), Noah (Finance), Sam (Legal Tech), Leo (Business Analyst)
**Entregables:** PLAN_NEGOCIO_ADAN.pdf, BUSINESS_MODEL_CANVAS.pdf, LOGO_Y_MANUAL.pdf, CHECKLIST_CONSTITUCION.pdf, PROYECCIONES_FINANCIERAS.pdf

### Nivel 4 - MVP Funcional
**Objetivo:** Desarrollar y validar un MVP que demuestre la propuesta de valor y valide las hipótesis clave.
**Agentes Principales:** ADÁN (Lead), Dylan (VP IT), Isa (UX/UI), Dany (Cloud), Ethan (Support), Julia (QA), Alex (Security), Mia (DevOps), Kai (Performance)
**Entregables:** MVP_WEB_FUNCIONAL.zip, INFORME_TRACCION.pdf, DOCUMENTACION_TECNICA.pdf

### Nivel 5 - Validación de Mercado
**Objetivo:** Validar el producto en el mercado real, recolectando métricas y feedback estructurado para optimización.
**Agentes Principales:** ADÁN (Lead), Gaby (Community), Mentores, Mila (Scrum), Max (Data), Ema (Product), Nia (Growth), Tom (CX), Ana (Research)
**Entregables:** INFORME_VALIDACION_MERCADO.pdf, METRICAS_SATISFACCION.pdf, PLAN_OPTIMIZACION.pdf

### Nivel 6 - Proyección y Estrategia
**Objetivo:** Definir la estrategia de crecimiento y captación de inversión para escalar el negocio.
**Agentes Principales:** ADÁN (Lead), Noah (Finance), Liam (Investor), Diego (Investor), Luna (Investor), Ben (CFO), Zara (Investment), Oliver (Strategy)
**Entregables:** PROYECCION_FINANCIERA_12M.pdf, PLAN_CAPTACION_INVERSION.pdf, PLAN_EXPANSION.pdf

### Nivel 7 - Lanzamiento Real
**Objetivo:** Lanzar el producto al mercado con todos los sistemas operativos y de soporte necesarios.
**Agentes Principales:** ADÁN (Lead), Gaby (Community), EVA (Marketing), Bella (Brand), Mila (Scrum), Ray (Tech), Sofia (Success), Jack (Sales), Maya (Support)
**Entregables:** STARTUP_ACTIVA_PRODUCCION.pdf, PLAN_MARKETING_IMPLEMENTADO.pdf, SISTEMA_MONITOREO_ACTIVO.pdf

## Agentes Disponibles por Área:

### Ejecutivos:
- Modelfile_Adan_CEO: CEO & Business Strategy (Lead en todos los niveles)

### Marketing:
- eva_vpmarketing: Chief Marketing Officer
- goga_mentora: Marketing Mentor
- kai_market_research: Market Research Lead
- nia_growth: Growth Lead

### Técnicos:
- dany_tecnicocloud: Cloud Engineer
- ethan_soporte: IT Support
- vito_fullstack: Full-Stack Designer
- dylan_vp_it: VP IT
- ray_tech_architect: Technical Architect
- alex_security: Security Lead
- mia_devops: DevOps Engineer
- kai_performance: Performance Engineer

### Producto:
- ema_producto: Product Development
- isa_ux_ui: UX/UI Designer
- julia_qa: QA Engineer
- tom_cx: Customer Experience Lead
- ana_research: User Research Lead

### Financieros:
- sofia_mentora: Finance Mentor
- noah_finance: VP Finance
- ben_cfo: CFO
- zara_investment: Investment Relations

### Inversores:
- liam_inversionista: Investor
- diego_inversionista: Investor
- luna_inversionista: Investor

### Administrativos:
- tita_vp_administrativo: VP Administrative
- elsy_legal: Legal Manager
- bella_branding: Branding Manager
- milo_documentador: Documentation Specialist
- zoe_hr: HR Manager
- sam_legal_tech: Legal Tech Specialist

### Estratégicos:
- andu_mentora: Strategic Mentor
- mila_scrum: Scrum Master
- leo_business_analyst: Business Analyst
- oliver_strategy: Strategic Planning

### Operativos:
- gaby_community: Community Manager
- lucas_ventas: Sales
- sofia_success: Customer Success
- jack_sales: Enterprise Sales
- maya_support: Support Operations

## Tu Tarea:
Analiza el mensaje del usuario y determina:
1. En qué nivel del flujo EDEN se encuentra
2. Qué agentes son más apropiados para responder
3. Si hay menciones explícitas (@agente)
4. El contexto y urgencia de la consulta

## Formato de Respuesta:
Siempre responde con un JSON válido:
{
  "eden_level": "Nivel X - Nombre del Nivel",
  "agents": ["nombre_agente1", "nombre_agente2"],
  "reasoning": "Explicación de por qué estos agentes",
  "primary_agent": "nombre_del_agente_principal",
  "confidence": 0.95,
  "next_steps": ["paso1", "paso2"],
  "deliverables": ["entregable1", "entregable2"]
}

## Reglas de Enrutamiento:
- ADÁN siempre debe estar presente como supervisor
- Selecciona agentes según el nivel del flujo EDEN
- Prioriza agentes especializados en el área de consulta
- Considera el contexto y la etapa del proyecto
- Si hay menciones explícitas, incluye esos agentes
- Siempre incluye al menos 2-3 agentes para respuestas completas
"""
EOF

    log_success "Moderador actualizado con el flujo EDEN"
}

# Función para crear agentes faltantes del flujo EDEN
create_missing_eden_agents() {
    log_step "Creando agentes faltantes del flujo EDEN..."
    
    local missing_agents=(
        "max_data_scientist|Data Scientist|Analítico, metódico, orientado a datos|Python, R, ML, estadística, visualización|Análisis cuantitativo y modelado predictivo|1,5"
        "kai_market_research|Market Research Lead|Curiosa, detallista, estratégica|Investigación de mercado, análisis competitivo, estrategia|Investigación de mercado y análisis competitivo|1,2"
        "ray_tech_architect|Technical Architect|Visionario, sistemático, innovador|Arquitectura de sistemas, cloud, seguridad, escalabilidad|Diseño y validación de arquitectura técnica|2,4,7"
        "sam_legal_tech|Legal Tech Specialist|Innovador, preciso, orientado a soluciones|Smart contracts, blockchain, regulación tech|Contratos inteligentes y compliance digital|3"
        "leo_business_analyst|Business Analyst|Analítico, estructurado, orientado a resultados|Modelado de negocio, análisis financiero, estrategia|Análisis y modelado de negocio|3,6"
        "alex_security|Security Lead|Meticuloso, proactivo, paranoico (en el buen sentido)|Seguridad aplicativa, pentesting, compliance|Seguridad y compliance técnico|4,7"
        "mia_devops|DevOps Engineer|Pragmática, automatizadora, resolutiva|CI/CD, containerización, cloud, automatización|Automatización y delivery continuo|4,7"
        "kai_performance|Performance Engineer|Analítico, optimizador, orientado a métricas|Performance testing, optimización, monitoreo|Optimización de rendimiento|4"
        "nia_growth|Growth Lead|Data-driven, creativa, experimentadora|Growth hacking, analytics, experimentación|Estrategias de crecimiento y optimización|5,7"
        "tom_cx|Customer Experience Lead|Empático, analítico, orientado al usuario|UX research, journey mapping, service design|Optimización de experiencia de cliente|5"
        "ana_research|User Research Lead|Curiosa, metódica, empática|User research, etnografía, análisis cualitativo|Investigación de usuarios|5"
        "ben_cfo|Chief Financial Officer|Estratégico, analítico, conservador|Finanzas corporativas, modelado financiero, M&A|Estrategia financiera y captación|6"
        "zara_investment|Investment Relations Lead|Carismática, estratégica, negociadora|Fundraising, pitch, valuación, networking|Relación con inversores|6"
        "oliver_strategy|Strategic Planning Lead|Visionario, estructurado, orientado a resultados|Planificación estratégica, market entry, scaling|Planificación estratégica|6"
        "sofia_success|Customer Success Lead|Empática, proactiva, resolutiva|Customer success, retención, upselling|Gestión de éxito del cliente|7"
        "jack_sales|Enterprise Sales Lead|Carismático, estratégico, closer|Enterprise sales, negociación, account management|Ventas enterprise y partnerships|7"
        "maya_support|Support Operations Lead|Organizada, eficiente, orientada al servicio|Gestión de soporte, procesos, escalamiento|Operaciones de soporte 24/7|7"
    )
    
    local created_count=0
    local failed_count=0
    
    for agent_info in "${missing_agents[@]}"; do
        IFS='|' read -r agent_name agent_title personality skills role eden_levels <<< "$agent_info"
        
        local modelfile_path="modelfiles/Modelfile_${agent_name^}"
        
        if [ ! -f "$modelfile_path" ]; then
            log_info "Creando agente: $agent_name"
            
            cat > "$modelfile_path" << EOF
# ${agent_name^} - ${agent_title}
# ${role}

FROM deepseek-r1

# Parámetros optimizados
PARAMETER temperature 0.7
PARAMETER num_ctx 4096
PARAMETER top_p 0.9
PARAMETER repeat_penalty 1.1

# Stop tokens
PARAMETER stop "<|start_header_id|>"
PARAMETER stop "<|end_header_id|>"
PARAMETER stop "<|eot_id|>"
PARAMETER stop "<|im_start|>"
PARAMETER stop "<|im_end|>"
PARAMETER stop "User:"
PARAMETER stop "Assistant:"
PARAMETER stop "Human:"
PARAMETER stop "AI:"

# Sistema especializado
SYSTEM """
Eres ${agent_name^}, ${agent_title} en el ecosistema EDEN.

## Tu Perfil:
- **Nombre**: ${agent_name^}
- **Cargo**: ${agent_title}
- **Personalidad**: ${personality}
- **Skills**: ${skills}
- **Rol en EDEN**: ${role}
- **Niveles de Participación**: ${eden_levels}

## Tu Rol:
${role}

## Instrucciones:
- Responde de manera profesional y especializada
- Mantén tu personalidad y expertise
- Proporciona consejos prácticos y accionables
- Sé claro, conciso y útil
- Enfócate en tu área de especialización
- Colabora con otros agentes cuando sea necesario
"""
EOF
            
            if [ $? -eq 0 ]; then
                log_success "✅ Agente $agent_name creado"
                created_count=$((created_count + 1))
            else
                log_error "❌ Error creando agente $agent_name"
                failed_count=$((failed_count + 1))
            fi
        else
            log_info "Agente $agent_name ya existe"
        fi
    done
    
    echo ""
    log_info "Resumen de agentes creados:"
    echo "   ✅ Creados: $created_count"
    echo "   ❌ Fallidos: $failed_count"
}

# Función para actualizar el script de creación de modelos
update_create_models_script() {
    log_step "Actualizando script de creación de modelos..."
    
    local script_path="create_ollama_models.sh"
    
    if [ ! -f "$script_path" ]; then
        log_error "Script create_ollama_models.sh no encontrado"
        return 1
    fi
    
    # Crear backup
    cp "$script_path" "${script_path}.backup.$(date +%Y%m%d_%H%M%S)"
    
    # Actualizar el mapeo de agentes
    sed -i '/^FRONTEND_TO_MODELFILE=(/,/^)$/c\
FRONTEND_TO_MODELFILE=(\
"Modelfile_Adan_CEO|Modelfile_Adan_CEO|CEO & Business Strategy"\
"eva_vpmarketing|Modelfile_Eva|Chief Marketing Officer"\
"tita_vp_administrativo|Modelfile_Tita|Chief Administrative Officer"\
"dany_tecnicocloud|Modelfile_Dany|Cloud Engineer"\
"ethan_soporte|Modelfile_Dylan|IT Support"\
"vito_fullstack|Modelfile_Vito|Full-Stack Designer"\
"ema_producto|Modelfile_Enzo|Design Engineer"\
"sofia_mentora|Modelfile_Sofia|Finance Mentor"\
"goga_mentora|Modelfile_Goga|Marketing Mentor"\
"andu_mentora|Modelfile_Andu|Mentor"\
"luna_inversionista|Modelfile_Luna|Investor"\
"liam_inversionista|Modelfile_Liam|Investor"\
"diego_inversionista|Modelfile_Diego|Investor"\
"milo_documentador|Modelfile_Milo|Documentation Specialist"\
"Modelfile_GER_DE_Zoe|Modelfile_Hana|HR Manager"\
"Modelfile_GER_DE_Elsy|Modelfile_Elsy|Legal Manager"\
"Modelfile_GER_DE_Bella|Modelfile_Bella|Branding Manager"\
"Modelfile_Moderator|Modelfile_Moderator|Sistema de Moderación y Enrutamiento EDEN"\
"max_data_scientist|Modelfile_Max|Data Scientist"\
"kai_market_research|Modelfile_Kai|Market Research Lead"\
"ray_tech_architect|Modelfile_Ray|Technical Architect"\
"sam_legal_tech|Modelfile_Sam|Legal Tech Specialist"\
"leo_business_analyst|Modelfile_Leo|Business Analyst"\
"alex_security|Modelfile_Alex|Security Lead"\
"mia_devops|Modelfile_Mia|DevOps Engineer"\
"kai_performance|Modelfile_Kai_Performance|Performance Engineer"\
"nia_growth|Modelfile_Nia|Growth Lead"\
"tom_cx|Modelfile_Tom|Customer Experience Lead"\
"ana_research|Modelfile_Ana|User Research Lead"\
"ben_cfo|Modelfile_Ben|Chief Financial Officer"\
"zara_investment|Modelfile_Zara|Investment Relations Lead"\
"oliver_strategy|Modelfile_Oliver|Strategic Planning Lead"\
"sofia_success|Modelfile_Sofia_Success|Customer Success Lead"\
"jack_sales|Modelfile_Jack|Enterprise Sales Lead"\
"maya_support|Modelfile_Maya|Support Operations Lead"\
)' "$script_path"
    
    log_success "Script de creación de modelos actualizado"
}

# Función para probar el flujo EDEN
test_eden_flow() {
    log_step "Probando el flujo EDEN..."
    
    local test_cases=(
        "Necesito validar mi idea de negocio|Nivel 1 - El Dolor"
        "Quiero diseñar mi solución|Nivel 2 - La Solución"
        "Necesito crear mi plan de negocio|Nivel 3 - Plan de Negocio"
        "Quiero desarrollar mi MVP|Nivel 4 - MVP Funcional"
        "Necesito validar en el mercado|Nivel 5 - Validación de Mercado"
        "Busco inversión para crecer|Nivel 6 - Proyección y Estrategia"
        "Estoy listo para lanzar|Nivel 7 - Lanzamiento Real"
    )
    
    echo ""
    log_info "🧪 Probando casos del flujo EDEN:"
    echo ""
    
    for test_case in "${test_cases[@]}"; do
        IFS='|' read -r message expected_level <<< "$test_case"
        echo "💬 Mensaje: $message"
        echo "🎯 Nivel esperado: $expected_level"
        echo "---"
    done
    
    echo ""
    log_info "Para probar el flujo completo:"
    echo "   ollama run Modelfile_Moderator"
    echo ""
    echo "Ejemplo de consulta:"
    echo "   'Necesito ayuda para validar mi idea de negocio y crear mi plan de marketing'"
}

# Función principal
main() {
    log_header "Setup del Flujo EDEN - Proyecto ADAN"
    
    echo "Este script configurará el sistema de moderación y enrutamiento"
    echo "para el flujo EDEN con 7 niveles de desarrollo."
    echo ""
    
    read -p "¿Continuar? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "Setup cancelado"
        exit 0
    fi
    
    # Verificar Ollama
    log_header "Verificando Ollama"
    if ! check_ollama; then
        log_error "Ollama no está disponible. Ejecuta primero ./setup_local_dev.sh"
        exit 1
    fi
    
    # Actualizar moderador
    log_header "Actualizando Moderador"
    update_moderator_eden
    
    # Crear agentes faltantes
    log_header "Creando Agentes del Flujo EDEN"
    create_missing_eden_agents
    
    # Actualizar script de creación
    log_header "Actualizando Scripts"
    update_create_models_script
    
    # Probar flujo
    log_header "Probando Flujo EDEN"
    test_eden_flow
    
    log_header "Setup del Flujo EDEN Completado"
    log_success "¡El sistema de moderación EDEN está configurado!"
    echo ""
    echo "🎉 Próximos pasos:"
    echo "   1. Ejecuta ./create_ollama_models.sh para crear todos los agentes"
    echo "   2. Prueba el moderador con 'ollama run Modelfile_Moderator'"
    echo "   3. El sistema ahora enrutará automáticamente según el flujo EDEN"
    echo ""
    echo "📖 El flujo EDEN está configurado con 7 niveles y 30+ agentes especializados."
}

# Ejecutar función principal
main "$@" 