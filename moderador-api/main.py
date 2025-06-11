from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional, List, Dict, Any
import os
from dotenv import load_dotenv
from controller import VLLMController
from agents.registry import AgentRegistry
from agents.moderator import ModeratorAgent
from agents.custom.content_filter import ContentFilterAgent

# Load environment variables
load_dotenv()

app = FastAPI(title="Moderador API")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize vLLM controller
vllm_controller = VLLMController(
    host=os.getenv("VLLM_HOST", "localhost"),
    port=int(os.getenv("VLLM_PORT", "8000"))
)

# Initialize agents
agents = {
    "moderator": AgentRegistry.get_agent("moderator"),
    "content_filter": AgentRegistry.get_agent("content_filter"),
    "adan": AgentRegistry.get_agent("adan"),
    "eva": AgentRegistry.get_agent("eva"),
    "gaby": AgentRegistry.get_agent("gaby"),
    "andu": AgentRegistry.get_agent("andu"),
    "goga": AgentRegistry.get_agent("goga"),
    "sofia": AgentRegistry.get_agent("sofia"),
    "max": AgentRegistry.get_agent("max"),
    "kai": AgentRegistry.get_agent("kai"),
    "isa": AgentRegistry.get_agent("isa"),
    "ema": AgentRegistry.get_agent("ema"),
    "ray": AgentRegistry.get_agent("ray"),
    "bella": AgentRegistry.get_agent("bella"),
    "elsy": AgentRegistry.get_agent("elsy"),
    "milo": AgentRegistry.get_agent("milo"),
    "tita": AgentRegistry.get_agent("tita"),
    "zoe": AgentRegistry.get_agent("zoe"),
    "noah": AgentRegistry.get_agent("noah"),
    "sam": AgentRegistry.get_agent("sam"),
    "leo": AgentRegistry.get_agent("leo"),
    "dylan": AgentRegistry.get_agent("dylan"),
    "dany": AgentRegistry.get_agent("dany"),
    "ethan": AgentRegistry.get_agent("ethan"),
    "julia": AgentRegistry.get_agent("julia"),
    "lucas": AgentRegistry.get_agent("lucas"),
    "mia": AgentRegistry.get_agent("mia"),
    "nia": AgentRegistry.get_agent("nia"),
    "tom": AgentRegistry.get_agent("tom"),
    "ana": AgentRegistry.get_agent("ana"),
    "ben": AgentRegistry.get_agent("ben"),
    "zara": AgentRegistry.get_agent("zara"),
    "liam": AgentRegistry.get_agent("liam"),
    "diego": AgentRegistry.get_agent("diego"),
    "luna": AgentRegistry.get_agent("luna"),
    "alex": AgentRegistry.get_agent("alex"),
    "jack": AgentRegistry.get_agent("jack"),
    "maya": AgentRegistry.get_agent("maya"),
    "mila": AgentRegistry.get_agent("mila"),
}

class GenerationRequest(BaseModel):
    prompt: str
    max_tokens: Optional[int] = 512
    temperature: Optional[float] = 0.7
    top_p: Optional[float] = 0.9
    stop: Optional[List[str]] = None
    use_agents: Optional[List[str]] = ["moderator"]  # Default to using moderator

class GenerationResponse(BaseModel):
    text: str
    usage: dict
    agent_results: Dict[str, Any]

@app.on_event("startup")
async def startup_event():
    """Initialize agents on startup."""
    for agent in agents.values():
        await agent.initialize()

@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup resources on shutdown."""
    for agent in agents.values():
        await agent.cleanup()
    await vllm_controller.close()

@app.get("/agents")
async def list_agents():
    """List all available agents."""
    return {
        "available_agents": list(AgentRegistry.list_agents().keys()),
        "active_agents": list(agents.keys())
    }

@app.post("/generate", response_model=GenerationResponse)
async def generate_text(request: GenerationRequest):
    try:
        # Convert request to dict for agent processing
        request_dict = request.dict()
        
        # Process through each requested agent
        agent_results = {}
        for agent_name in request.use_agents:
            if agent_name not in agents:
                raise HTTPException(
                    status_code=400,
                    detail=f"Agent '{agent_name}' not found"
                )
            
            agent = agents[agent_name]
            
            # Validate request through agent
            if not await agent.validate(request_dict):
                raise HTTPException(
                    status_code=400,
                    detail=f"Request failed validation by agent '{agent_name}'"
                )
            
            # Process request through agent
            agent_result = await agent.process(request_dict)
            agent_results[agent_name] = agent_result
        
        # Generate text using vLLM
        response = await vllm_controller.generate(
            prompt=request.prompt,
            max_tokens=request.max_tokens,
            temperature=request.temperature,
            top_p=request.top_p,
            stop=request.stop
        )
        
        # Add agent results to response
        response["agent_results"] = agent_results
        
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    return {
        "status": "healthy",
        "services": {
            "vllm": "connected",
            "agents": {
                name: "initialized" if agent.is_initialized() else "not_initialized"
                for name, agent in agents.items()
            }
        }
    }

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8004) 