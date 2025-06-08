from typing import Dict, Any, List
import re
from .base import BaseAgent
from .registry import AgentRegistry

@AgentRegistry.register("moderator")
class ModeratorAgent(BaseAgent):
    """Agent responsible for content moderation and request validation."""
    
    def __init__(self, config: Dict[str, Any] = None):
        super().__init__(config)
        self.blocked_patterns: List[str] = []
        self.max_prompt_length: int = 4096
        self.max_tokens: int = 512
    
    async def initialize(self) -> None:
        """Initialize the moderator agent with blocked patterns and limits."""
        self.blocked_patterns = self.config.get('blocked_patterns', [
            r'(?i)(porn|sex|nude|explicit)',
            r'(?i)(hack|crack|warez|pirate)',
            r'(?i)(kill|murder|suicide|harm)',
            r'(?i)(drug|illegal|weapon)'
        ])
        self.max_prompt_length = self.config.get('max_prompt_length', 4096)
        self.max_tokens = self.config.get('max_tokens', 512)
        self.initialized = True
    
    async def validate(self, input_data: Dict[str, Any]) -> bool:
        """Validate the input data for content and length."""
        if not self.initialized:
            await self.initialize()
        
        # Check prompt presence
        if 'prompt' not in input_data:
            return False
        
        prompt = input_data['prompt']
        
        # Check prompt length
        if len(prompt) > self.max_prompt_length:
            return False
        
        # Check for blocked patterns
        for pattern in self.blocked_patterns:
            if re.search(pattern, prompt):
                return False
        
        # Validate generation parameters
        if 'max_tokens' in input_data and input_data['max_tokens'] > self.max_tokens:
            return False
        
        if 'temperature' in input_data and not 0 <= input_data['temperature'] <= 1:
            return False
        
        if 'top_p' in input_data and not 0 <= input_data['top_p'] <= 1:
            return False
        
        return True
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process the input data and add moderation metadata."""
        if not self.initialized:
            await self.initialize()
        
        # Add moderation metadata
        result = {
            'original_input': input_data,
            'moderation': {
                'passed': True,
                'checks': {
                    'length': len(input_data['prompt']) <= self.max_prompt_length,
                    'content': True,
                    'parameters': True
                }
            }
        }
        
        return result 