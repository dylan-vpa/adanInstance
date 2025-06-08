# 🚀 Adan Instance

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python](https://img.shields.io/badge/Python-3.8%2B-blue)](https://www.python.org/)
[![Docker](https://img.shields.io/badge/Docker-20.10%2B-blue)](https://www.docker.com/)
[![FastAPI](https://img.shields.io/badge/FastAPI-0.68%2B-green)](https://fastapi.tiangolo.com/)
[![vLLM](https://img.shields.io/badge/vLLM-0.2%2B-orange)](https://github.com/vllm-project/vllm)

<div style="border-left: 4px solid #FF6B6B; padding-left: 15px; margin: 20px 0;">
A high-performance, scalable system for running and fine-tuning large language models, with a focus on moderation and content filtering.
</div>

## 📁 Project Structure

```
.
├── 📂 models/                 # Downloaded and fine-tuned models
├── 📂 moderador-api/         # FastAPI application
│   ├── 📂 agents/           # Agent implementations
│   │   ├── 📂 custom/      # Custom agent implementations
│   │   └── 📄 base.py      # Base agent class
│   ├── 📂 api/             # API endpoints
│   └── 📄 main.py          # FastAPI application entry point
├── 📂 fine-tuning/          # Fine-tuning system
│   ├── 📂 config/          # Training configurations
│   ├── 📂 data/            # Training data
│   ├── 📂 scripts/         # Training scripts
│   └── 📂 models/          # Fine-tuned models
├── 📂 nginx/                # Nginx configuration
│   ├── 📄 nginx.conf       # Main Nginx configuration
│   └── 📄 Dockerfile       # Nginx Dockerfile
├── 📂 scripts/              # Management scripts
│   ├── 📄 manage.py        # Main management script
│   └── 📄 download_model.py # Model download script
├── 📄 docker-compose.yml    # Docker Compose configuration
└── 📄 README.md            # Project documentation
```

## ✨ Features

- 🤖 **Agent System**: Modular and extensible agent architecture
- 🚀 **High Performance**: Powered by vLLM for efficient inference
- 🔒 **Security**: Built-in content filtering and moderation
- 🎯 **Fine-tuning**: Support for model fine-tuning
- 🌐 **API**: RESTful API with FastAPI
- 🐳 **Containerized**: Docker-based deployment
- 📊 **Monitoring**: Integrated logging and metrics

## 🛠️ Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/adan-instance.git
   cd adan-instance
   ```

2. **Install dependencies**:
   ```bash
   pip install -r requirements.txt
   ```

3. **Start the management interface**:
   ```bash
   python scripts/manage.py
   ```

## 📡 API Endpoints

### Base URL
- Production: `https://api.server.adan.run`
- Development: `http://localhost:8001`

### Endpoints

#### Generate Text
```http
POST /api/v1/generate
Content-Type: application/json

{
    "prompt": "Your prompt here",
    "max_tokens": 100,
    "temperature": 0.7
}
```

#### Moderate Content
```http
POST /api/v1/moderate
Content-Type: application/json

{
    "text": "Content to moderate",
    "filters": ["toxicity", "violence"]
}
```

## ⚙️ Configuration

### Environment Variables

```bash
# vLLM Server
MODEL_NAME=mistralai/Mixtral-8x7B-Instruct-v0.1
MODEL_PATH=/models
GPU_MEMORY_UTILIZATION=0.9

# API Server
API_HOST=0.0.0.0
API_PORT=8001
VLLM_SERVER_URL=http://vllm-server:8000
```

### Fine-tuning Configuration

```python
# fine-tuning/config/finetune_config.py
base_model: str = "mistralai/Mixtral-8x7B-Instruct-v0.1"
num_train_epochs: int = 3
learning_rate: float = 2e-5
per_device_train_batch_size: int = 4
```

## 🌐 Nginx Configuration

### Server Blocks

```nginx
# API Server
server {
    listen 80;
    server_name api.server.adan.run;
    
    location / {
        proxy_pass http://moderador-api:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

# Frontend Server
server {
    listen 80;
    server_name server.adan.run;
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
    
    location /api {
        proxy_pass http://moderador-api:8001;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## 🐳 Docker Compose

```yaml
version: '3.8'

services:
  nginx:
    build: ./nginx
    ports:
      - "80:80"
      - "443:443"
    volumes:
      - ./nginx/ssl:/etc/nginx/ssl
      - ./nginx/logs:/var/log/nginx
    depends_on:
      - moderador-api
    networks:
      - adan-network

  vllm-server:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - ./models:/models
      - ./fine-tuning/models:/fine-tuning/models
    environment:
      - MODEL_NAME=mistralai/Mixtral-8x7B-Instruct-v0.1
      - MODEL_PATH=/models
      - GPU_MEMORY_UTILIZATION=0.9
    deploy:
      resources:
        reservations:
          devices:
            - driver: nvidia
              count: 1
              capabilities: [gpu]
    networks:
      - adan-network

  moderador-api:
    build: ./moderador-api
    ports:
      - "8001:8001"
    volumes:
      - ./models:/models
      - ./fine-tuning:/fine-tuning
    environment:
      - VLLM_SERVER_URL=http://vllm-server:8000
    networks:
      - adan-network

networks:
  adan-network:
    driver: bridge
```

## 📋 Requirements

- Python 3.8+
- CUDA-compatible GPU
- Docker and Docker Compose
- NVIDIA Container Toolkit

## 👨‍💻 Development

### Adding a New Agent

1. Create a new file in `moderador-api/agents/custom/`:
   ```python
   from ..base import BaseAgent
   from ..registry import AgentRegistry

   @AgentRegistry.register("my_agent")
   class MyAgent(BaseAgent):
       async def process(self, input_data):
           # Your implementation here
           return {"result": "processed"}
   ```

2. Register the agent in `moderador-api/agents/__init__.py`

### Fine-tuning a Model

1. Prepare your training data in JSON format
2. Use the management script:
   ```bash
   python scripts/manage.py
   ```
3. Select "Manage Fine-tuning" and follow the prompts

## 🔧 Troubleshooting

### Common Issues

1. **GPU Memory Issues**
   - Adjust `GPU_MEMORY_UTILIZATION` in environment variables
   - Use a smaller model or batch size

2. **API Connection Issues**
   - Check if all services are running: `docker-compose ps`
   - Verify network connectivity: `docker network inspect adan-network`

3. **Fine-tuning Errors**
   - Ensure sufficient GPU memory
   - Check training data format
   - Verify model compatibility

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 