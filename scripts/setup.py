# -*- coding: utf-8 -*-
#!/usr/bin/env python3
import os
import json
try:
    from pathlib import Path
except ImportError:
    # Para Python 2.x, define Path como un wrapper de os.path
    class Path(unicode):
        def __new__(cls, *args):
            return unicode(os.path.join(*args))
        def mkdir(self, exist_ok=False):
            if not os.path.exists(self):
                os.makedirs(self)
        def exists(self):
            return os.path.exists(self)
        def __truediv__(self, other):
            return Path(os.path.join(self, other))
        def __div__(self, other):
            return Path(os.path.join(self, other))
        def iterdir(self):
            return [Path(os.path.join(self, f)) for f in os.listdir(self) if os.path.isdir(os.path.join(self, f))]
        def is_dir(self):
            return os.path.isdir(self)
        def is_file(self):
            return os.path.isfile(self)

def create_directory_structure():
    directories = [
        "datasets",
        "models_finetuned", 
        "models_ollama",
        "logs",
        "scripts",
        "templates",
        "backups"
    ]
    for directory in directories:
        if hasattr(Path(directory), "mkdir"):
            Path(directory).mkdir(exist_ok=True)
        else:
            if not os.path.exists(directory):
                os.makedirs(directory)
        print("[OK] Directorio creado: {}".format(directory))

def create_infobase_json():
    infobase_path = Path("infobase.json")
    # Compatibilidad para Python 2.x (Path es un unicode)
    if hasattr(infobase_path, "exists"):
        exists = infobase_path.exists()
    else:
        exists = os.path.exists(infobase_path)
    if exists:
        print("[OK] infobase.json ya existe")
        return
    infobase = {
        "EDEN": {
            "introduccion": "EDEN es un ecosistema gamificado de última generación que transforma ideas de negocio en startups exitosas, operativas y escalables. El proceso está estructurado en 7 niveles, cada uno con objetivos específicos, acciones detalladas, entregables profesionales y un equipo especializado de agentes que aseguran la calidad y el éxito en cada etapa.",
            "niveles": [
                {
                    "nivel": 1,
                    "nombre": "El Dolor (Validación del Problema)",
                    "objetivo": "Validar científicamente que el problema detectado es real, urgente, frecuente y monetizable.",
                    "acciones_clave": [
                        "Investigación de Mercado: Análisis cuantitativo del TAM/SAM/SOM, estudios de tendencias y comportamiento, análisis de competencia y soluciones existentes",
                        "Validación con Usuarios: Entrevistas estructuradas (mínimo 15), encuestas cuantitativas (100+ respuestas), tests de concepto",
                        "Análisis de Datos: Procesamiento de feedback, cálculo de métricas clave, validación de hipótesis"
                    ],
                    "entregables": [
                        "DIAGNOSTICO_DOLOR.pdf: Análisis cuantitativo y cualitativo, evidencia estadística, insights de usuarios, métricas de validación",
                        "SCORE_OPORTUNIDAD.pdf: Matriz de evaluación, análisis de factibilidad, proyecciones iniciales, recomendaciones",
                        "VALIDACION_CLIENTES.pdf: Resultados de entrevistas, análisis de patrones, evidencia de disposición a pagar, insights clave"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de oportunidad: 8/10",
                        "Mínimo 15 entrevistas validadas",
                        "Pago de 5 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 2,
                    "nombre": "La Solución (Validación de la Idea)",
                    "objetivo": "Definir y validar la solución propuesta, asegurando su viabilidad técnica y ajuste al mercado.",
                    "acciones_clave": [
                        "Desarrollo de Prototipo: Creación de un prototipo funcional de la solución",
                        "Pruebas de Usuario: Evaluación del prototipo con usuarios reales, recopilando feedback cualitativo y cuantitativo",
                        "Iteración de la Solución: Refinamiento de la solución basado en el feedback recibido"
                    ],
                    "entregables": [
                        "PROTOIPO_SOLUCION.pdf: Documentación del prototipo, decisiones de diseño, arquitectura técnica",
                        "RESULTADOS_PRUEBAS.pdf: Análisis de resultados de pruebas de usuario, métricas de usabilidad, feedback cualitativo",
                        "ITERACION_FINAL.pdf: Descripción de la solución final, justificación de decisiones, preparación para desarrollo"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de solución: 8/10",
                        "Prototipo funcional completado",
                        "Pago de 10 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 3,
                    "nombre": "El Producto Mínimo Viable (PMV)",
                    "objetivo": "Desarrollar un PMV que permita testar la solución en el mercado con el menor esfuerzo y costo.",
                    "acciones_clave": [
                        "Desarrollo Ágil: Implementación del PMV usando metodologías ágiles, priorizando funcionalidades críticas",
                        "Estrategia Go-To-Market: Definición de la propuesta de valor, segmentación de clientes y canales de distribución",
                        "Métricas de Éxito: Establecimiento de KPIs claros para medir la aceptación y uso del PMV"
                    ],
                    "entregables": [
                        "PRODUCTO_MINIMO_VIABLE.pdf: Especificaciones del PMV, roadmap de desarrollo, criterios de aceptación",
                        "EVALUACION_MERCADO.pdf: Análisis de viabilidad comercial, identificación de early adopters, proyecciones de demanda",
                        "METRICAS_EXITO.pdf: Definición y cálculo de KPIs, herramientas de seguimiento, umbrales de éxito"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de PMV: 8/10",
                        "Desarrollo del PMV completado",
                        "Pago de 15 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 4,
                    "nombre": "La Validación del Mercado",
                    "objetivo": "Comprobar la aceptación del producto en el mercado y ajustar la estrategia comercial.",
                    "acciones_clave": [
                        "Lanzamiento del PMV: Introducción del PMV en el mercado con una campaña de marketing inicial",
                        "Recopilación de Feedback: Obtención de opiniones y datos de uso de los primeros usuarios",
                        "Iteración Comercial: Ajustes en la estrategia de marketing, ventas y producto basados en el feedback"
                    ],
                    "entregables": [
                        "INFORME_LANZAMIENTO.pdf: Resultados del lanzamiento, análisis de métricas de uso y ventas, feedback de usuarios",
                        "ITERACION_COMERCIAL.pdf: Cambios realizados en la estrategia comercial, justificación basada en datos",
                        "PLAN_ESCALAMIENTO.pdf: Estrategia para escalar el producto, identificación de nuevos segmentos de mercado, proyecciones de crecimiento"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de validación: 8/10",
                        "Estrategia comercial ajustada y validada",
                        "Pago de 20 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 5,
                    "nombre": "El Escalado",
                    "objetivo": "Preparar el producto y la organización para un crecimiento rápido y sostenible.",
                    "acciones_clave": [
                        "Optimización del Producto: Mejoras en el producto basadas en el feedback del mercado y análisis de uso",
                        "Escalado de la Infraestructura: Asegurar que la infraestructura técnica puede soportar un aumento en la demanda",
                        "Fortalecimiento del Equipo: Contratación y capacitación de nuevo talento, definición de roles y responsabilidades"
                    ],
                    "entregables": [
                        "OPTIMIZACION_PRODUCTO.pdf: Cambios realizados en el producto, mejoras de rendimiento, nuevas funcionalidades",
                        "INFRAESTRUCTURA_ESCALADO.pdf: Plan de escalado de infraestructura, proveedores, costos asociados",
                        "PLAN_RECURSOS_HUMANOS.pdf: Estrategia de contratación, perfiles buscados, plan de capacitación"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de escalado: 8/10",
                        "Infraestructura y equipo listos para escalar",
                        "Pago de 25 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 6,
                    "nombre": "La Búsqueda de Inversión",
                    "objetivo": "Atraer inversores que aporten capital y valor a la startup.",
                    "acciones_clave": [
                        "Preparación de Pitch: Creación de una presentación convincente que destaque la oportunidad, el producto y el equipo",
                        "Identificación de Inversores: Investigación y selección de potenciales inversores que se alineen con la visión de la startup",
                        "Reuniones con Inversores: Presentación del pitch y negociación de términos de inversión"
                    ],
                    "entregables": [
                        "PITCH_DE_INVERSION.pdf: Presentación para inversores, incluyendo proyecciones financieras, análisis de mercado y estrategia de salida",
                        "LISTA_INVERSIONISTAS.pdf: Base de datos de potenciales inversores, estado del contacto, notas de reuniones",
                        "TERMINOS_INVERSION.pdf: Borrador de términos y condiciones para la inversión, incluyendo valoración, porcentaje de equity, derechos y obligaciones"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de inversión: 8/10",
                        "Pitch y materiales de inversión listos",
                        "Pago de 30 USD en @pple coins"
                    ]
                },
                {
                    "nivel": 7,
                    "nombre": "La Salida (Exit)",
                    "objetivo": "Lograr una salida exitosa que maximice el retorno de inversión para los fundadores e inversores.",
                    "acciones_clave": [
                        "Estrategia de Salida: Definición de la estrategia de salida, ya sea venta, fusión o salida a bolsa",
                        "Preparación para la Salida: Asegurar que la empresa cumple con todos los requisitos legales, financieros y operativos para la salida",
                        "Ejecución de la Salida: Llevar a cabo la transacción de salida, asegurando el mejor retorno posible"
                    ],
                    "entregables": [
                        "ESTRATEGIA_SALIDA.pdf: Plan detallado de la estrategia de salida, incluyendo cronograma, objetivos y métricas de éxito",
                        "DOCUMENTACION_SALIDA.pdf: Todos los documentos legales y financieros necesarios para la transacción de salida",
                        "INFORME_POST_SALIDA.pdf: Análisis de la transacción de salida, lecciones aprendidas, recomendaciones para futuros fundadores"
                    ],
                    "agentes_principales": ["ADÁN", "EVA", "Gaby", "Mentores (Andu, Goga, Sofia)", "Max", "Kai"],
                    "condicion_avance": [
                        "Validación del equipo ADÁN",
                        "Score mínimo de salida: 8/10",
                        "Estrategia de salida aprobada",
                        "Pago de 35 USD en @pple coins"
                    ]
                }
            ]
        },
        "agentes": [
            {
                "nombre": "ADÁN",
                "rol": "CEO",
                "especialidad": "Visión de negocio, estrategia, liderazgo",
                "bio": "Adán es el CEO y cofundador de EDEN. Con una trayectoria en la creación y escalado de startups, Adán aporta su visión estratégica y habilidades de liderazgo para guiar a los fundadores en su viaje emprendedor.",
                "foto": "https://example.com/foto_adam.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/adan",
                    "twitter": "https://twitter.com/adan",
                    "facebook": "https://facebook.com/adan"
                }
            },
            {
                "nombre": "EVA",
                "rol": "CFO",
                "especialidad": "Finanzas, contabilidad, gestión de inversiones",
                "bio": "Eva es la CFO de EDEN, responsable de la salud financiera de la organización y de asegurar una gestión eficiente de los recursos. Con experiencia en finanzas corporativas y contabilidad, Eva guía a los fundadores en la planificación y gestión financiera.",
                "foto": "https://example.com/foto_eva.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/eva",
                    "twitter": "https://twitter.com/eva",
                    "facebook": "https://facebook.com/eva"
                }
            },
            {
                "nombre": "Gaby",
                "rol": "CMO",
                "especialidad": "Marketing, ventas, desarrollo de negocio",
                "bio": "Gaby es la CMO de EDEN, experta en crear estrategias de marketing efectivas y en impulsar el crecimiento de las startups. Con un enfoque en resultados y una mentalidad creativa, Gaby ayuda a los fundadores a posicionar y escalar sus negocios.",
                "foto": "https://example.com/foto_gaby.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/gaby",
                    "twitter": "https://twitter.com/gaby",
                    "facebook": "https://facebook.com/gaby"
                }
            },
            {
                "nombre": "Mentores (Andu, Goga, Sofia)",
                "rol": "Mentores",
                "especialidad": "Diversas especialidades según el mentor",
                "bio": "Nuestro equipo de mentores está compuesto por expertos con amplia experiencia en diversas áreas clave para el éxito de las startups. Proporcionan orientación, consejos y conexiones valiosas a los fundadores.",
                "foto": "https://example.com/foto_mentores.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/mentores",
                    "twitter": "https://twitter.com/mentores",
                    "facebook": "https://facebook.com/mentores"
                }
            },
            {
                "nombre": "Max",
                "rol": "CTO",
                "especialidad": "Tecnología, desarrollo de producto, innovación",
                "bio": "Max es el CTO de EDEN, responsable de guiar el desarrollo tecnológico y la innovación en las startups. Con un fuerte enfoque en la creación de productos viables y escalables, Max ayuda a los fundadores a transformar sus ideas en realidades tecnológicas.",
                "foto": "https://example.com/foto_max.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/max",
                    "twitter": "https://twitter.com/max",
                    "facebook": "https://facebook.com/max"
                }
            },
            {
                "nombre": "Kai",
                "rol": "COO",
                "especialidad": "Operaciones, gestión de proyectos, optimización",
                "bio": "Kai es el COO de EDEN, experto en optimizar operaciones y en asegurar que las startups funcionen de manera eficiente y efectiva. Con habilidades en gestión de proyectos y un enfoque en la mejora continua, Kai apoya a los fundadores en la construcción de organizaciones ágiles y resilientes.",
                "foto": "https://example.com/foto_kai.jpg",
                "redes": {
                    "linkedin": "https://www.linkedin.com/in/kai",
                    "twitter": "https://twitter.com/kai",
                    "facebook": "https://facebook.com/kai"
                }
            }
        ]
    }
    if hasattr(infobase_path, "write"):
        with open(infobase_path, "w", encoding="utf-8") as f:
            json.dump(infobase, f, indent=2, ensure_ascii=False)
    else:
        with open(str(infobase_path), "w") as f:
            json.dump(infobase, f, indent=2, ensure_ascii=False)
    print("[OK] Archivo base creado: infobase.json")

def extract_agents_from_infobase():
    infobase_path = Path("infobase.json")
    # Compatibilidad para Python 2.x (Path es un unicode)
    if hasattr(infobase_path, "exists"):
        exists = infobase_path.exists()
    else:
        exists = os.path.exists(infobase_path)
    if not exists:
        print("[ERROR] infobase.json no encontrado")
        return []
    # Abrir archivo
    if hasattr(infobase_path, "open"):
        f = open(infobase_path, "r", encoding="utf-8")
    else:
        f = open(str(infobase_path), "r")
    with f:
        data = json.load(f)
    agents = []
    for agent in data.get("agentes", []):
        name = agent["nombre"]
        folder = name.lower().replace(" ", "_").replace("(", "").replace(")", "").replace(",", "")
        agents.append(folder)
        print("[OK] Agente detectado: {}".format(folder))
    return agents

def create_agent_datasets(agents):
    # Abrir archivo infobase.json compatible
    infobase_path = Path("infobase.json")
    if hasattr(infobase_path, "open"):
        f = open(infobase_path, "r", encoding="utf-8")
    else:
        f = open(str(infobase_path), "r")
    with f:
        infobase_text = f.read()
    for agent in agents:
        agent_dir = Path("datasets/{}".format(agent))
        # mkdir compatible
        if hasattr(agent_dir, "mkdir"):
            agent_dir.mkdir(exist_ok=True)
        else:
            if not os.path.exists(agent_dir):
                os.makedirs(agent_dir)
        train_file = agent_dir / "train.json"
        eval_file = agent_dir / "eval.json"
        # exists compatible
        if hasattr(train_file, "exists"):
            train_exists = train_file.exists()
        else:
            train_exists = os.path.exists(str(train_file))
        if not train_exists:
            sample_data = [
                {
                    "instruction": u"¿Cuál es tu rol como {} en el ecosistema EDEN?".format(agent),
                    "input": "",
                    "output": u"Como {}, mi rol principal es contribuir específicamente en mi área de expertise dentro del ecosistema EDEN, trabajando colaborativamente con otros agentes para lograr los objetivos del proyecto.".format(agent)
                },
                {
                    "instruction": u"Preséntate brevemente",
                    "input": "",
                    "output": u"Hola, soy {}. Trabajo en el ecosistema EDEN aportando mis habilidades especializadas para el éxito de los proyectos.".format(agent)
                },
                {
                    "instruction": u"¿Qué es EDEN y cómo funciona el flujo de niveles?",
                    "input": "",
                    "output": infobase_text[:2000]
                }
            ]
            # open compatible
            if hasattr(train_file, "open"):
                ftrain = open(train_file, 'w', encoding='utf-8')
            else:
                ftrain = open(str(train_file), 'w')
            with ftrain:
                json.dump(sample_data, ftrain, indent=2, ensure_ascii=False)
            print("[OK] Creado dataset de ejemplo para {}: train.json".format(agent))
        if hasattr(eval_file, "exists"):
            eval_exists = eval_file.exists()
        else:
            eval_exists = os.path.exists(str(eval_file))
        if not eval_exists:
            sample_eval = [
                {
                    "instruction": u"¿Cuál es tu mayor fortaleza como {}?".format(agent),
                    "input": "",
                    "output": u"Mi mayor fortaleza es mi expertise especializada y mi capacidad de trabajar colaborativamente en el ecosistema EDEN."
                },
                {
                    "instruction": u"¿Cómo manejas situaciones complejas?",
                    "input": "",
                    "output": "Analizo la situación desde mi perspectiva experta, consulto con otros agentes cuando es necesario y propongo soluciones estructuradas y viables."
                }
            ]
            if hasattr(eval_file, "open"):
                feval = open(eval_file, 'w', encoding='utf-8')
            else:
                feval = open(str(eval_file), 'w')
            with feval:
                json.dump(sample_eval, feval, indent=2, ensure_ascii=False)
            print("[OK] Creado dataset de evaluación para {}: eval.json".format(agent))

def create_config_file():
    config = {
        "base_model": "deepseek-r1",
        "training_defaults": {
            "num_train_epochs": 3,
            "per_device_train_batch_size": 4,
            "per_device_eval_batch_size": 4,
            "warmup_steps": 100,
            "learning_rate": 2e-4,
            "fp16": True,
            "gradient_checkpointing": True,
            "dataloader_num_workers": 4,
            "save_steps": 500,
            "eval_steps": 500,
            "logging_steps": 10,
            "max_grad_norm": 1.0
        },
        "lora_config": {
            "r": 16,
            "lora_alpha": 32,
            "target_modules": ["q_proj", "k_proj", "v_proj", "o_proj"],
            "lora_dropout": 0.1,
            "bias": "none",
            "task_type": "CAUSAL_LM"
        },
        "model_max_length": 2048,
        "output_dir": "models_finetuned"
    }
    with open("config.json", 'w', encoding='utf-8') as f:
        json.dump(config, f, indent=2)
    print("[OK] Archivo de configuración creado: config.json")

def create_requirements_file():
    requirements = [
        "torch>=2.0.0",
        "transformers>=4.35.0",
        "datasets>=2.14.0",
        "peft>=0.6.0",
        "accelerate>=0.24.0",
        "bitsandbytes>=0.41.0",
        "scipy>=1.10.0",
        "scikit-learn>=1.3.0",
        "tqdm>=4.65.0",
        "wandb>=0.15.0",
        "tensorboard>=2.14.0"
    ]
    with open("requirements.txt", 'w') as f:
        f.write('\n'.join(requirements))
    print("[OK] Archivo de dependencias creado: requirements.txt")

def create_validation_script():
    validation_script = '''#!/usr/bin/env python3
import json
from pathlib import Path

def validate_dataset(file_path):
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            data = json.load(f)
        if not isinstance(data, list):
            return False, "Dataset debe ser una lista"
        for i, item in enumerate(data):
            if not isinstance(item, dict):
                return False, "Item {} no es un diccionario".format(i)
            required_keys = ['instruction', 'input', 'output']
            for key in required_keys:
                if key not in item:
                    return False, "Item {} falta clave '{}'".format(i, key)
                if not isinstance(item[key], str):
                    return False, "Item {} clave '{}' no es string".format(i, key)
        return True, "Dataset válido con {} ejemplos".format(len(data))
    except Exception as e:
        return False, "Error: {}".format(str(e))

def main():
    datasets_dir = Path("datasets")
    if not datasets_dir.exists():
        print("[ERROR] Directorio datasets no encontrado")
        return
    total_valid = 0
    total_files = 0
    for agent_dir in datasets_dir.iterdir():
        if agent_dir.is_dir():
            print("\\n[OK] Validando agente: {}".format(agent_dir.name))
            for dataset_file in ['train.json', 'eval.json']:
                file_path = agent_dir / dataset_file
                total_files += 1
                if file_path.exists():
                    is_valid, message = validate_dataset(file_path)
                    status = "[OK]" if is_valid else "[ERROR]"
                    print("  {} {}: {}".format(status, dataset_file, message))
                    if is_valid:
                        total_valid += 1
                else:
                    print("  [ERROR] {}: Archivo no encontrado".format(dataset_file))
    print("\\n[OK] Resumen: {}/{} archivos válidos".format(total_valid, total_files))

if __name__ == "__main__":
    main()
'''
    with open("scripts/validate_datasets.py", 'w', encoding='utf-8') as f:
        f.write(validation_script)
    os.chmod("scripts/validate_datasets.py", 0o755)
    print("[OK] Script de validación creado: scripts/validate_datasets.py")

def main():
    print("=== Configurando sistema de fine-tuning para modelos Ollama ===")
    print("\n[INFO] Creando estructura de directorios...")
    create_directory_structure()
    print("\n[INFO] Creando archivo infobase.json (si no existe)...")
    create_infobase_json()
    print("\n[INFO] Detectando agentes desde infobase.json...")
    agents = extract_agents_from_infobase()
    if not agents:
        print("[ERROR] No se encontraron agentes en infobase.json")
        return
    print("\n[INFO] Creando datasets de ejemplo para cada agente...")
    create_agent_datasets(agents)
    print("\n[INFO] Creando archivos de configuración y dependencias...")
    create_config_file()
    create_requirements_file()
    create_validation_script()
    print("\n=== Setup completado exitosamente! ===")
    print("\n[INFO] Próximos pasos:")
    print("1. Instalar dependencias: pip install -r requirements.txt")
    print("2. Editar datasets en datasets/[agente]/train.json y eval.json")
    print("3. Validar datos: python scripts/validate_datasets.py")
    print("4. Ejecutar fine-tuning: python scripts/finetune_model.py --agent_name [agente]")
    print("\nVer README.md para instrucciones detalladas")

if __name__ == "__main__":
    main()
