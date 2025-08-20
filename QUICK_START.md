# 🚀 Inicio Rápido - Proyecto ADAN

## ⚡ Setup en 5 Minutos

### 1️⃣ Ejecutar Setup Completo (Recomendado)

```bash
cd adanInstance
chmod +x setup_complete.sh
./setup_complete.sh
```

**Selecciona opción 1** para setup completo automático.

### 2️⃣ Setup Manual (Paso a Paso)

```bash
# 1. Instalar Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Iniciar Ollama
ollama serve

# 3. Descargar modelo base
ollama pull deepseek-r1

# 4. Generar modelfiles
./generate_clean_modelfiles.sh

# 5. Crear agentes
./create_ollama_models.sh

# 6. Configurar flujo EDEN
./setup_eden_flow.sh

# 7. Configurar aplicación
./setup_app_local.sh
```

## 🎯 Pruebas Rápidas

### Probar Moderador
```bash
ollama run Modelfile_Moderator
```

### Probar Agente Principal
```bash
ollama run Modelfile_Adan_CEO
```

### Ejecutar Pruebas Completas
```bash
./test_eden_flow.sh
```

## 🌐 Iniciar Aplicación

```bash
cd ../app
pnpm dev
```

Abrir: http://localhost:3000

## 🔧 Comandos Útiles

```bash
# Listar modelos disponibles
ollama list

# Ver estado del sistema
./setup_complete.sh  # Opción 5

# Limpiar y resetear
./setup_complete.sh  # Opción 6
```

## 📋 Variables de Entorno Requeridas

Crear `../app/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=tu_url_supabase
NEXT_PUBLIC_SUPABASE_ANON_KEY=tu_clave_anonima
OLLAMA_BASE_URL=http://localhost:11434/v1/chat/completions
```

## 🚨 Solución de Problemas

### Ollama no responde
```bash
pkill ollama
ollama serve
```

### Modelos no se crean
```bash
ollama pull deepseek-r1
./create_ollama_models.sh
```

### Aplicación no inicia
```bash
cd ../app
rm -rf node_modules
pnpm install
pnpm dev
```

## 📚 Recursos

- **Documentación Completa**: `README_SETUP_LOCAL.md`
- **Configuración EDEN**: `eden_flow_config.json`
- **Scripts de Setup**: `setup_*.sh`
- **Pruebas**: `test_*.sh`

## 🎉 ¡Listo!

Tu entorno de desarrollo local está configurado con:
- ✅ 30+ agentes IA especializados
- ✅ Sistema de moderación EDEN
- ✅ Aplicación web Next.js
- ✅ Flujo completo de desarrollo de startups

**¡Comienza a transformar ideas en startups exitosas! 🚀** 