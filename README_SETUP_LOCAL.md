# 🚀 Setup Local - Proyecto ADAN

Este documento explica cómo configurar el entorno de desarrollo local para el proyecto ADAN, incluyendo el sistema de agentes IA y la aplicación web.

## 📋 Requisitos Previos

- **Sistema Operativo**: Linux, macOS, o Windows (con WSL)
- **Memoria RAM**: Mínimo 8GB, recomendado 16GB+
- **Espacio en Disco**: Mínimo 10GB para modelos de IA
- **Conexión a Internet**: Para descargar modelos y dependencias

## 🛠️ Instalación Rápida

### Opción 1: Setup Automático (Recomendado)

```bash
# Navegar al directorio del proyecto
cd adanInstance

# Hacer ejecutable el script de setup
chmod +x setup_local_dev.sh

# Ejecutar setup completo
./setup_local_dev.sh
```

### Opción 2: Setup Manual

Si prefieres configurar paso a paso:

```bash
# 1. Instalar Ollama
curl -fsSL https://ollama.ai/install.sh | sh

# 2. Iniciar Ollama
ollama serve

# 3. Descargar modelo base
ollama pull deepseek-r1

# 4. Generar modelfiles
./generate_clean_modelfiles.sh

# 5. Crear modelos
./create_ollama_models.sh
```

## 🎯 Configuración del Flujo EDEN

Para configurar el sistema de moderación y enrutamiento del flujo EDEN:

```bash
# Configurar flujo EDEN
./setup_eden_flow.sh

# Crear todos los agentes
./create_ollama_models.sh
```

## 🏗️ Arquitectura del Sistema

### Componentes Principales

1. **Ollama**: Motor de IA local para ejecutar modelos
2. **Agentes Especializados**: 30+ agentes con roles específicos
3. **Moderador**: Sistema de enrutamiento inteligente
4. **Flujo EDEN**: 7 niveles de desarrollo de startups

### Agentes por Nivel EDEN

#### Nivel 1 - El Dolor (Validación del Problema)
- **ADÁN** (Lead): Supervisión y validación final
- **EVA**: Análisis de mercado y tendencias
- **Gaby**: Gestión de entrevistas y feedback
- **Mentores**: Validación estratégica
- **Max**: Análisis cuantitativo
- **Kai**: Investigación de mercado

#### Nivel 2 - La Solución (Diseño y Validación)
- **ADÁN** (Lead): Supervisión y validación
- **Isa**: Diseño de experiencia de usuario
- **Ema**: Desarrollo de producto
- **Ray**: Arquitectura técnica
- **Bella**: Diferenciación y posicionamiento
- **Kai**: Análisis competitivo

#### Nivel 3 - Plan de Negocio y Constitución
- **ADÁN** (Lead): Supervisión general
- **Elsy**: Constitución y compliance
- **Bella**: Identidad corporativa
- **Milo**: Documentación técnica
- **Tita**: Procesos y estructura
- **Zoe**: Organización y cultura
- **Noah**: Proyecciones y modelos
- **Sam**: Contratos inteligentes
- **Leo**: Modelado de negocio

#### Nivel 4 - MVP Funcional
- **ADÁN** (Lead): Supervisión general
- **Dylan**: Liderazgo técnico
- **Isa**: Experiencia de usuario
- **Dany**: Infraestructura
- **Ethan**: Soporte técnico
- **Julia**: Testing y calidad
- **Alex**: Seguridad y compliance
- **Mia**: CI/CD y automatización
- **Kai**: Optimización

#### Nivel 5 - Validación de Mercado
- **ADÁN** (Lead): Supervisión general
- **Gaby**: Gestión de usuarios
- **Mentores**: Validación estratégica
- **Mila**: Gestión de proceso
- **Max**: Análisis de datos
- **Ema**: Optimización
- **Nia**: Métricas de crecimiento
- **Tom**: Experiencia de cliente
- **Ana**: Investigación de usuarios

#### Nivel 6 - Proyección y Estrategia
- **ADÁN** (Lead): Supervisión general
- **Noah**: Modelado financiero
- **Liam**: Valuación
- **Diego**: Due diligence
- **Luna**: Estrategia
- **Ben**: Finanzas estratégicas
- **Zara**: Relación con inversores
- **Oliver**: Planificación estratégica

#### Nivel 7 - Lanzamiento Real
- **ADÁN** (Lead): Supervisión general
- **Gaby**: Gestión de comunidad
- **EVA**: Estrategia de marketing
- **Bella**: Comunicación
- **Mila**: Coordinación
- **Ray**: Infraestructura
- **Sofia**: Customer success
- **Jack**: Ventas enterprise
- **Maya**: Soporte 24/7

## 🔧 Comandos Útiles

### Gestión de Ollama

```bash
# Listar modelos disponibles
ollama list

# Ejecutar un agente específico
ollama run Modelfile_Adan_CEO

# Eliminar un modelo
ollama rm nombre_modelo

# Descargar un modelo
ollama pull nombre_modelo

# Iniciar servidor
ollama serve
```

### Testing del Sistema

```bash
# Probar sistema de moderación
./test_moderation.sh

# Probar flujo EDEN
ollama run Modelfile_Moderator
```

### Desarrollo de la Aplicación

```bash
# Navegar a la app
cd ../app

# Instalar dependencias
pnpm install

# Ejecutar en modo desarrollo
pnpm dev

# Construir para producción
pnpm build
```

## 🌐 Configuración de Variables de Entorno

Crear archivo `.env.local` en el directorio `adanInstance`:

```env
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
```

## 🧪 Pruebas del Sistema

### Prueba Básica de Moderación

```bash
# Ejecutar pruebas automáticas
./test_moderation.sh

# Prueba manual del moderador
ollama run Modelfile_Moderator
```

### Ejemplos de Consultas

1. **Validación de Idea**: "Necesito validar mi idea de negocio"
2. **Diseño de Solución**: "Quiero diseñar mi solución"
3. **Plan de Negocio**: "Necesito crear mi plan de negocio"
4. **Desarrollo MVP**: "Quiero desarrollar mi MVP"
5. **Validación de Mercado**: "Necesito validar en el mercado"
6. **Búsqueda de Inversión**: "Busco inversión para crecer"
7. **Lanzamiento**: "Estoy listo para lanzar"

## 🚨 Solución de Problemas

### Ollama no responde

```bash
# Verificar si está ejecutándose
ps aux | grep ollama

# Reiniciar servicio
pkill ollama
ollama serve
```

### Modelos no se crean

```bash
# Verificar espacio en disco
df -h

# Verificar memoria disponible
free -h

# Limpiar modelos no utilizados
ollama list | grep -v "deepseek-r1" | awk '{print $1}' | xargs -I {} ollama rm {}
```

### Errores de permisos

```bash
# Hacer ejecutables los scripts
chmod +x *.sh

# Verificar permisos
ls -la *.sh
```

## 📚 Recursos Adicionales

- **Documentación de Ollama**: https://ollama.ai/docs
- **Documentación de Next.js**: https://nextjs.org/docs
- **Flujo EDEN**: Documentación interna del proyecto
- **Base de Conocimiento**: Directorio `infobase/`

## 🤝 Contribución

Para contribuir al proyecto:

1. Fork del repositorio
2. Crear rama feature: `git checkout -b feature/nueva-funcionalidad`
3. Commit cambios: `git commit -am 'Agregar nueva funcionalidad'`
4. Push a la rama: `git push origin feature/nueva-funcionalidad`
5. Crear Pull Request

## 📞 Soporte

Si encuentras problemas:

1. Revisar la sección de solución de problemas
2. Verificar logs de Ollama: `ollama logs`
3. Crear issue en el repositorio
4. Contactar al equipo de desarrollo

---

**¡El entorno de desarrollo local está listo para el proyecto ADAN! 🎉** 