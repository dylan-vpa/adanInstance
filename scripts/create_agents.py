import os

AGENTS = [
    ("adan", "Chief Executive Officer. Líder maestro, responsable de la validación final en cada nivel, guía al usuario y coordina la interacción entre agentes. Supervisa la calidad, asegura el cumplimiento de entregables y valida los pagos."),
    ("eva", "Vicepresidente de Marketing. Análisis de mercado y tendencias, diseño de estrategias de marketing, storytelling y funnels de conversión."),
    ("gaby", "Community Manager. Gestión de entrevistas y feedback, comunicación digital, interacción con usuarios y gestión de comunidades."),
    ("andu", "Mentora. Validación estratégica, feedback crítico y guía estratégica."),
    ("goga", "Mentora. Validación estratégica, feedback crítico y guía estratégica."),
    ("sofia", "Mentora. Validación estratégica, feedback crítico y guía estratégica."),
    ("max", "Data Scientist. Análisis cuantitativo y modelado predictivo."),
    ("kai", "Market Research Lead. Investigación de mercado y análisis competitivo."),
    ("isa", "UX/UI IT. Diseño de experiencia de usuario y prototipos."),
    ("ema", "Desarrollo de Producto. Desarrollo de producto y validación de propuesta de valor."),
    ("ray", "Technical Architect. Diseño y validación de arquitectura técnica."),
    ("bella", "Gerente de Branding. Creación de identidad visual y de marca, diferenciación y posicionamiento."),
    ("elsy", "Gerente de Auditoría. Revisión de cumplimiento legal, fiscal y de procesos."),
    ("milo", "Documentadora. Documentación de procesos, manuales y checklist."),
    ("tita", "Vicepresidente Administrativo. Organización administrativa, procesos y estructura."),
    ("zoe", "Gerente de RRHH. Selección de personal, procesos de RRHH y clima organizacional."),
    ("noah", "Vicepresidente de Finanzas. Proyecciones financieras, valuación y análisis de costos."),
    ("sam", "Legal Tech Specialist. Contratos inteligentes y compliance digital."),
    ("leo", "Business Analyst. Análisis y modelado de negocio."),
    ("dylan", "VP de IT. Liderazgo técnico y desarrollo de prototipos."),
    ("dany", "Técnico Cloud. Infraestructura tecnológica y soporte técnico."),
    ("ethan", "Soporte IT. Soporte técnico y testing."),
    ("julia", "Tester IT. Testing de prototipos y soporte."),
    ("lucas", "Ventas. Estrategia comercial y cierre de ventas."),
    ("mia", "DevOps Engineer. Automatización y delivery continuo."),
    ("nia", "Growth Lead. Estrategias de crecimiento y optimización."),
    ("tom", "Customer Experience Lead. Optimización de experiencia de cliente."),
    ("ana", "User Research Lead. Investigación de usuarios."),
    ("ben", "Chief Financial Officer. Estrategia financiera y captación."),
    ("zara", "Investment Relations Lead. Relación con inversores."),
    ("liam", "Inversionista. Evaluación de modelos de negocio y ROI."),
    ("diego", "Inversionista. Evaluación de modelos de negocio y ROI."),
    ("luna", "Inversionista. Evaluación de modelos de negocio y ROI."),
    ("alex", "Security Lead. Seguridad y compliance técnico."),
    ("jack", "Enterprise Sales Lead. Ventas enterprise y partnerships."),
    ("maya", "Support Operations Lead. Operaciones de soporte 24/7."),
    ("mila", "Scrum Master. Facilitación ágil y coordinación de equipos."),
    ("noah", "Vicepresidente de Finanzas. Proyecciones financieras y análisis de riesgos."),
]

AGENTS_DIR = os.path.join(os.path.dirname(__file__), "../moderador-api/agents/custom")

AGENT_TEMPLATE = '''from typing import Dict, Any
from ..base import BaseAgent
from ..registry import AgentRegistry

@AgentRegistry.register("{agent_name}")
class {class_name}(BaseAgent):
    """
    {description}
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        super().__init__(config)
        self.initialized = False
    
    async def initialize(self) -> None:
        """Initialize the {class_name} agent."""
        # TODO: Add initialization code
        self.initialized = True
    
    async def validate(self, input_data: Dict[str, Any]) -> bool:
        """Validate the input data."""
        # TODO: Add validation logic
        return True
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process the input and return results."""
        # TODO: Add processing logic
        return {{"result": "processed"}}
'''

def create_agent_file(agent_name: str, description: str):
    class_name = agent_name.title() + "Agent"
    file_name = f"{agent_name.lower()}.py"
    file_path = os.path.join(AGENTS_DIR, file_name)
    
    content = AGENT_TEMPLATE.format(
        agent_name=agent_name.lower(),
        class_name=class_name,
        description=description
    )
    
    with open(file_path, "w") as f:
        f.write(content)
    print(f"Created agent file: {file_path}")

def main():
    if not os.path.exists(AGENTS_DIR):
        os.makedirs(AGENTS_DIR)
    
    for agent_name, description in AGENTS:
        create_agent_file(agent_name, description)

if __name__ == "__main__":
    main()
