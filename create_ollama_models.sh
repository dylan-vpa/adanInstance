#!/bin/bash

# Script para crear modelos en Ollama usando los modelfiles existentes
# Mapeo de nombres del frontend a los modelfiles reales

echo "🚀 Creando modelos en Ollama..."
echo "📁 Directorio actual: $(pwd)"
echo ""

# Mapeo de nombres del frontend a los modelfiles existentes
# Formato: nombre_frontend|nombre_modelfile|descripción
FRONTEND_TO_MODELFILE=(
"Modelfile_Adan_CEO|Modelfile_Adan_CEO|CEO & Business Strategy"
"eva_vpmarketing|Modelfile_Eva|Chief Marketing Officer"
"tita_vp_administrativo|Modelfile_Tita|Chief Administrative Officer"
"dany_tecnicocloud|Modelfile_Dany|Cloud Engineer"
"ethan_soporte|Modelfile_Dylan|IT Support"
"vito_fullstack|Modelfile_Vito|Full-Stack Designer"
"ema_producto|Modelfile_Enzo|Design Engineer"
"sofia_mentora|Modelfile_Sofia|Finance Mentor"
"goga_mentora|Modelfile_Goga|Marketing Mentor"
"andu_mentora|Modelfile_Andu|Mentor"
"luna_inversionista|Modelfile_Luna|Investor"
"liam_inversionista|Modelfile_Liam|Investor"
"diego_inversionista|Modelfile_Diego|Investor"
"milo_documentador|Modelfile_Milo|Documentation Specialist"
"Modelfile_GER_DE_Zoe|Modelfile_Hana|HR Manager"
"Modelfile_GER_DE_Elsy|Modelfile_Elsy|Legal Manager"
"Modelfile_GER_DE_Bella|Modelfile_Bella|Branding Manager"
"Modelfile_Moderator|Modelfile_Moderator|Sistema de Moderación y Enrutamiento EDEN"
"max_data_scientist|Modelfile_Max|Data Scientist"
"kai_market_research|Modelfile_Kai|Market Research Lead"
"ray_tech_architect|Modelfile_Ray|Technical Architect"
"sam_legal_tech|Modelfile_Sam|Legal Tech Specialist"
"leo_business_analyst|Modelfile_Leo|Business Analyst"
"alex_security|Modelfile_Alex|Security Lead"
"mia_devops|Modelfile_Mia|DevOps Engineer"
"kai_performance|Modelfile_Kai_Performance|Performance Engineer"
"nia_growth|Modelfile_Nia|Growth Lead"
"tom_cx|Modelfile_Tom|Customer Experience Lead"
"ana_research|Modelfile_Ana|User Research Lead"
"ben_cfo|Modelfile_Ben|Chief Financial Officer"
"zara_investment|Modelfile_Zara|Investment Relations Lead"
"oliver_strategy|Modelfile_Oliver|Strategic Planning Lead"
"sofia_success|Modelfile_Sofia_Success|Customer Success Lead"
"jack_sales|Modelfile_Jack|Enterprise Sales Lead"
"maya_support|Modelfile_Maya|Support Operations Lead"
)

# Contadores para estadísticas
total_models=0
created_models=0
failed_models=0

echo "📋 Modelos a crear:"
for mapping in "${FRONTEND_TO_MODELFILE[@]}"; do
    IFS='|' read -r frontend_name modelfile_name description <<< "$mapping"
    echo "   🔧 $frontend_name -> $modelfile_name ($description)"
    total_models=$((total_models + 1))
done
echo ""

# Función para crear un modelo
create_model() {
    local frontend_name=$1
    local modelfile_name=$2
    local description=$3
    
    echo "🔧 Creando modelo: $frontend_name"
    echo "   📄 Usando modelfile: $modelfile_name"
    echo "   📝 Descripción: $description"
    
    # Verificar si existe el modelfile
    if [ ! -f "modelfiles/$modelfile_name" ]; then
        echo "   ❌ Error: Modelfile no encontrado: modelfiles/$modelfile_name"
        return 1
    fi
    
    # Verificar si el modelo ya existe en Ollama
    if ollama list | grep -q "^$frontend_name"; then
        echo "   ⚠️  Modelo ya existe: $frontend_name"
        echo "   🔄 Eliminando modelo existente..."
        ollama rm "$frontend_name" 2>/dev/null
    fi
    
    # Crear el modelo
    echo "   🚀 Ejecutando: ollama create $frontend_name -f modelfiles/$modelfile_name"
    if ollama create "$frontend_name" -f "modelfiles/$modelfile_name"; then
        echo "   ✅ Modelo creado exitosamente: $frontend_name"
        return 0
    else
        echo "   ❌ Error al crear modelo: $frontend_name"
        return 1
    fi
}

# Función para mostrar progreso
show_progress() {
    local current=$1
    local total=$2
    local percentage=$((current * 100 / total))
    echo "📊 Progreso: $current/$total ($percentage%)"
}

# Crear todos los modelos
echo "🎯 Iniciando creación de modelos..."
echo ""

for mapping in "${FRONTEND_TO_MODELFILE[@]}"; do
    IFS='|' read -r frontend_name modelfile_name description <<< "$mapping"
    
    if create_model "$frontend_name" "$modelfile_name" "$description"; then
        created_models=$((created_models + 1))
    else
        failed_models=$((failed_models + 1))
    fi
    
    show_progress $((created_models + failed_models)) $total_models
    echo ""
done

# Mostrar resumen final
echo "🎉 Proceso completado!"
echo ""
echo "📊 Resumen:"
echo "   ✅ Modelos creados exitosamente: $created_models"
echo "   ❌ Modelos fallidos: $failed_models"
echo "   📋 Total procesados: $total_models"
echo ""

# Listar modelos creados
echo "📋 Modelos disponibles en Ollama:"
ollama list | grep -E "($(printf '%s|' "${FRONTEND_TO_MODELFILE[@]}" | sed 's/|.*$//g' | tr '\n' '|' | sed 's/|$//'))" || echo "   No se encontraron modelos del proyecto"

echo ""
echo "🔧 Para usar un modelo:"
echo "   ollama run [nombre_modelo]"
echo ""
echo "📝 Ejemplos:"
echo "   ollama run Modelfile_Adan_CEO"
echo "   ollama run eva_vpmarketing"
echo "   ollama run sofia_mentora" 