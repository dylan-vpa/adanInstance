from typing import Dict, Any, List
import re
from ..base import BaseAgent
from ..registry import AgentRegistry

@AgentRegistry.register("content_filter")
class ContentFilterAgent(BaseAgent):
    """Agent for advanced content filtering and categorization."""
    
    def __init__(self, config: Dict[str, Any] = None):
        super().__init__(config)
        self.categories = {
            'technical': r'(?i)(code|programming|algorithm|software|hardware)',
            'creative': r'(?i)(art|music|poetry|story|creative)',
            'academic': r'(?i)(research|study|academic|science|education)',
            'business': r'(?i)(business|finance|marketing|strategy|management)'
        }
        self.initialized = False
    
    async def initialize(self) -> None:
        """Initialize the content filter agent."""
        # Load custom categories from config if provided
        if 'categories' in self.config:
            self.categories.update(self.config['categories'])
        self.initialized = True
    
    async def validate(self, input_data: Dict[str, Any]) -> bool:
        """Validate the input data."""
        if not self.initialized:
            await self.initialize()
        
        if 'prompt' not in input_data:
            return False
        
        return True
    
    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process the input and categorize content."""
        if not self.initialized:
            await self.initialize()
        
        prompt = input_data['prompt']
        categories_found = []
        
        # Check each category
        for category, pattern in self.categories.items():
            if re.search(pattern, prompt):
                categories_found.append(category)
        
        result = {
            'original_input': input_data,
            'content_analysis': {
                'categories': categories_found,
                'is_technical': 'technical' in categories_found,
                'is_creative': 'creative' in categories_found,
                'is_academic': 'academic' in categories_found,
                'is_business': 'business' in categories_found
            }
        }
        
        return result 