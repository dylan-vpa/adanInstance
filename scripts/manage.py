#!/usr/bin/env python3
import os
import sys
import json
from pathlib import Path
import subprocess
import logging
from typing import Dict, Any, List

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

class AdanManager:
    def __init__(self):
        self.base_dir = Path(__file__).parent.parent
        self.models_dir = self.base_dir / "models"
        self.agents_dir = self.base_dir / "moderador-api/agents/custom"
        self.finetuning_dir = self.base_dir / "fine-tuning"
        
        # Create necessary directories
        self.models_dir.mkdir(parents=True, exist_ok=True)
        self.agents_dir.mkdir(parents=True, exist_ok=True)
        self.finetuning_dir.mkdir(parents=True, exist_ok=True)

    def clear_screen(self):
        os.system('cls' if os.name == 'nt' else 'clear')

    def print_header(self, title: str):
        self.clear_screen()
        print("=" * 80)
        print(f"🚀 {title}")
        print("=" * 80)
        print()

    def get_user_input(self, prompt: str, options: List[str] = None) -> str:
        while True:
            user_input = input(f"{prompt} ").strip()
            if options and user_input not in options:
                print(f"Invalid option. Please choose from: {', '.join(options)}")
                continue
            return user_input

    def manage_models(self):
        self.print_header("Model Management")
        
        # Available models
        models = {
            "1": "mistralai/Mixtral-8x7B-Instruct-v0.1",
            "2": "mistralai/Mistral-7B-Instruct-v0.2",
            "3": "meta-llama/Llama-2-7b-chat-hf",
            "4": "tiiuae/falcon-7b-instruct"
        }
        
        print("Available models:")
        for key, model in models.items():
            print(f"{key}. {model}")
        print()
        
        choice = self.get_user_input("Select a model to download (1-4):", list(models.keys()))
        model_name = models[choice]
        
        # Check if model already exists
        model_dir = self.models_dir / model_name.split("/")[-1]
        if model_dir.exists():
            overwrite = self.get_user_input(
                f"Model {model_name} already exists. Overwrite? (y/n):",
                ["y", "n"]
            )
            if overwrite == "n":
                return
        
        # Download model
        print(f"\nDownloading {model_name}...")
        try:
            subprocess.run([
                "python", "scripts/download_model.py",
                "--model", model_name,
                "--output", str(model_dir)
            ], check=True)
            print(f"Model {model_name} downloaded successfully!")
            
            # Update environment variables
            os.environ["MODEL_NAME"] = model_name
            print(f"Model {model_name} set as default for vLLM server")
            
        except subprocess.CalledProcessError as e:
            print(f"Error downloading model: {e}")
            return

    def manage_agents(self):
        self.print_header("Agent Management")
        
        # Get agent details
        agent_name = self.get_user_input("Enter agent name (e.g., sentiment_analyzer):")
        agent_description = self.get_user_input("Enter agent description:")
        
        # Create agent file
        agent_file = self.agents_dir / f"{agent_name}.py"
        
        # Agent template
        agent_template = f'''from typing import Dict, Any
from ..base import BaseAgent
from ..registry import AgentRegistry

@AgentRegistry.register("{agent_name}")
class {agent_name.title()}Agent(BaseAgent):
    """
    {agent_description}
    """
    
    def __init__(self, config: Dict[str, Any] = None):
        super().__init__(config)
        self.initialized = False

    async def initialize(self) -> None:
        """Initialize agent resources"""
        # TODO: Add initialization code
        self.initialized = True

    async def validate(self, input_data: Dict[str, Any]) -> bool:
        """Validate input data"""
        # TODO: Add validation logic
        return True

    async def process(self, input_data: Dict[str, Any]) -> Dict[str, Any]:
        """Process input and return results"""
        # TODO: Add processing logic
        return {{"result": "processed"}}
'''
        
        # Write agent file
        with open(agent_file, 'w') as f:
            f.write(agent_template)
        
        print(f"\nAgent {agent_name} created successfully!")
        print(f"File location: {agent_file}")
        print("\nPlease implement the TODO sections in the agent file.")

    def manage_finetuning(self):
        self.print_header("Fine-tuning Management")
        
        # Get fine-tuning configuration
        print("Fine-tuning Configuration")
        print("-" * 40)
        
        base_model = self.get_user_input("Enter base model name (e.g., mistralai/Mixtral-8x7B-Instruct-v0.1):")
        num_epochs = int(self.get_user_input("Enter number of training epochs (default: 3):") or "3")
        learning_rate = float(self.get_user_input("Enter learning rate (default: 2e-5):") or "2e-5")
        batch_size = int(self.get_user_input("Enter batch size (default: 4):") or "4")
        
        # Update configuration
        config_file = self.finetuning_dir / "config/finetune_config.py"
        with open(config_file, 'r') as f:
            config_content = f.read()
        
        # Update configuration values
        config_content = config_content.replace(
            'base_model: str = "mistralai/Mixtral-8x7B-Instruct-v0.1"',
            f'base_model: str = "{base_model}"'
        )
        config_content = config_content.replace(
            'num_train_epochs: int = 3',
            f'num_train_epochs: int = {num_epochs}'
        )
        config_content = config_content.replace(
            'learning_rate: float = 2e-5',
            f'learning_rate: float = {learning_rate}'
        )
        config_content = config_content.replace(
            'per_device_train_batch_size: int = 4',
            f'per_device_train_batch_size: int = {batch_size}'
        )
        
        with open(config_file, 'w') as f:
            f.write(config_content)
        
        print("\nConfiguration updated successfully!")
        
        # Ask about data preparation
        prepare_data = self.get_user_input(
            "Do you want to prepare training data now? (y/n):",
            ["y", "n"]
        )
        
        if prepare_data == "y":
            data_file = self.get_user_input("Enter path to your conversations JSON file:")
            try:
                subprocess.run([
                    "python", "fine-tuning/scripts/prepare_data.py",
                    "--input", data_file
                ], check=True)
                print("Data preparation completed successfully!")
            except subprocess.CalledProcessError as e:
                print(f"Error preparing data: {e}")
                return
        
        # Ask about starting training
        start_training = self.get_user_input(
            "Do you want to start training now? (y/n):",
            ["y", "n"]
        )
        
        if start_training == "y":
            try:
                subprocess.run([
                    "python", "fine-tuning/scripts/train.py"
                ], check=True)
                print("Training started successfully!")
                
                # After training, update the model in vLLM
                update_vllm = self.get_user_input(
                    "Do you want to update vLLM with the fine-tuned model? (y/n):",
                    ["y", "n"]
                )
                
                if update_vllm == "y":
                    os.environ["MODEL_NAME"] = str(self.finetuning_dir / "models/finetuned")
                    print("Fine-tuned model set as default for vLLM server")
                    
            except subprocess.CalledProcessError as e:
                print(f"Error starting training: {e}")
                return

    def manage_services(self):
        self.print_header("Service Management")
        
        print("1. Start all services")
        print("2. Stop all services")
        print("3. Restart all services")
        print("4. View logs")
        print("5. Back to main menu")
        print()
        
        choice = self.get_user_input("Select an option (1-5):", ["1", "2", "3", "4", "5"])
        
        if choice == "1":
            subprocess.run(["docker-compose", "up", "-d"])
        elif choice == "2":
            subprocess.run(["docker-compose", "down"])
        elif choice == "3":
            subprocess.run(["docker-compose", "restart"])
        elif choice == "4":
            service = self.get_user_input(
                "Enter service name (nginx/vllm-server/moderador-api):",
                ["nginx", "vllm-server", "moderador-api"]
            )
            subprocess.run(["docker-compose", "logs", "-f", service])
        elif choice == "5":
            return

    def main_menu(self):
        while True:
            self.print_header("Adan Instance Manager")
            print("1. Manage Models")
            print("2. Manage Agents")
            print("3. Manage Fine-tuning")
            print("4. Manage Services")
            print("5. Exit")
            print()
            
            choice = self.get_user_input("Select an option (1-5):", ["1", "2", "3", "4", "5"])
            
            if choice == "1":
                self.manage_models()
            elif choice == "2":
                self.manage_agents()
            elif choice == "3":
                self.manage_finetuning()
            elif choice == "4":
                self.manage_services()
            elif choice == "5":
                print("\nGoodbye!")
                break
            
            input("\nPress Enter to continue...")

if __name__ == "__main__":
    manager = AdanManager()
    manager.main_menu() 