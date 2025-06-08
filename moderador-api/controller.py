import aiohttp
import json
from typing import Optional, List, Dict, Any

class VLLMController:
    def __init__(self, host: str = "localhost", port: int = 8000):
        self.base_url = f"http://{host}:{port}"
        self.session = None

    async def _get_session(self) -> aiohttp.ClientSession:
        if self.session is None or self.session.closed:
            self.session = aiohttp.ClientSession()
        return self.session

    async def generate(
        self,
        prompt: str,
        max_tokens: int = 512,
        temperature: float = 0.7,
        top_p: float = 0.9,
        stop: Optional[List[str]] = None
    ) -> Dict[str, Any]:
        """
        Generate text using the vLLM server.
        """
        session = await self._get_session()
        
        payload = {
            "prompt": prompt,
            "max_tokens": max_tokens,
            "temperature": temperature,
            "top_p": top_p,
            "stop": stop or []
        }

        try:
            async with session.post(
                f"{self.base_url}/v1/completions",
                json=payload
            ) as response:
                if response.status != 200:
                    error_text = await response.text()
                    raise Exception(f"vLLM server error: {error_text}")
                
                result = await response.json()
                return {
                    "text": result["choices"][0]["text"],
                    "usage": result["usage"]
                }
        except Exception as e:
            raise Exception(f"Error communicating with vLLM server: {str(e)}")

    async def close(self):
        """
        Close the aiohttp session.
        """
        if self.session and not self.session.closed:
            await self.session.close() 