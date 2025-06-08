from typing import Dict, Type, Any
from .base import BaseAgent

class AgentRegistry:
    """Registry for managing available agents."""
    
    _instance = None
    _agents: Dict[str, Type[BaseAgent]] = {}
    
    def __new__(cls):
        if cls._instance is None:
            cls._instance = super(AgentRegistry, cls).__new__(cls)
        return cls._instance
    
    @classmethod
    def register(cls, name: str) -> callable:
        """Decorator to register an agent class."""
        def decorator(agent_class: Type[BaseAgent]) -> Type[BaseAgent]:
            cls._agents[name] = agent_class
            return agent_class
        return decorator
    
    @classmethod
    def get_agent(cls, name: str, config: Dict[str, Any] = None) -> BaseAgent:
        """Get an instance of a registered agent."""
        if name not in cls._agents:
            raise ValueError(f"Agent '{name}' not found in registry")
        return cls._agents[name](config)
    
    @classmethod
    def list_agents(cls) -> Dict[str, Type[BaseAgent]]:
        """List all registered agents."""
        return cls._agents.copy()
    
    @classmethod
    def clear(cls) -> None:
        """Clear the agent registry."""
        cls._agents.clear() 