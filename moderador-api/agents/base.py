from abc import ABC, abstractmethod
from typing import Dict, Any, Optional

class BaseAgent(ABC):
    """Base class for all agents in the system."""
    
    def __init__(self, config: Optional[Dict[str, Any]] = None):
        self.config = config or {}
        self.initialized = False
    
    @abstractmethod
    async def initialize(self) -> None:
        """Initialize the agent with necessary resources."""
        pass
    
    @abstractmethod
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process the input data and return the result."""
        pass
    
    @abstractmethod
    async def validate(self, input_data: Dict[str, Any]) -> bool:
        """Validate the input data."""
        pass
    
    async def cleanup(self) -> None:
        """Clean up resources used by the agent."""
        pass
    
    def is_initialized(self) -> bool:
        """Check if the agent is initialized."""
        return self.initialized 