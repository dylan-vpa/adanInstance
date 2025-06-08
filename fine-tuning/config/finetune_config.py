from dataclasses import dataclass
from typing import Optional, List, Dict, Any
import torch

@dataclass
class FineTuneConfig:
    # Model Configuration
    base_model: str = "mistralai/Mixtral-8x7B-Instruct-v0.1"
    model_output_dir: str = "models/finetuned"
    
    # Training Configuration
    num_train_epochs: int = 3
    per_device_train_batch_size: int = 4
    gradient_accumulation_steps: int = 4
    learning_rate: float = 2e-5
    weight_decay: float = 0.01
    warmup_ratio: float = 0.03
    
    # LoRA Configuration
    use_lora: bool = True
    lora_r: int = 16
    lora_alpha: int = 32
    lora_dropout: float = 0.05
    lora_target_modules: List[str] = ["q_proj", "k_proj", "v_proj", "o_proj"]
    
    # Dataset Configuration
    train_file: str = "data/train.json"
    validation_file: str = "data/validation.json"
    max_seq_length: int = 2048
    
    # Optimization
    optimizer: str = "adamw_torch"
    lr_scheduler_type: str = "cosine"
    fp16: bool = True
    bf16: bool = False
    
    # Checkpointing
    save_steps: int = 100
    save_total_limit: int = 3
    evaluation_strategy: str = "steps"
    eval_steps: int = 100
    
    # Logging
    logging_steps: int = 10
    logging_dir: str = "logs"
    
    # Device Configuration
    device_map: str = "auto"
    
    def to_dict(self) -> Dict[str, Any]:
        return {
            "base_model": self.base_model,
            "model_output_dir": self.model_output_dir,
            "num_train_epochs": self.num_train_epochs,
            "per_device_train_batch_size": self.per_device_train_batch_size,
            "gradient_accumulation_steps": self.gradient_accumulation_steps,
            "learning_rate": self.learning_rate,
            "weight_decay": self.weight_decay,
            "warmup_ratio": self.warmup_ratio,
            "use_lora": self.use_lora,
            "lora_r": self.lora_r,
            "lora_alpha": self.lora_alpha,
            "lora_dropout": self.lora_dropout,
            "lora_target_modules": self.lora_target_modules,
            "train_file": self.train_file,
            "validation_file": self.validation_file,
            "max_seq_length": self.max_seq_length,
            "optimizer": self.optimizer,
            "lr_scheduler_type": self.lr_scheduler_type,
            "fp16": self.fp16,
            "bf16": self.bf16,
            "save_steps": self.save_steps,
            "save_total_limit": self.save_total_limit,
            "evaluation_strategy": self.evaluation_strategy,
            "eval_steps": self.eval_steps,
            "logging_steps": self.logging_steps,
            "logging_dir": self.logging_dir,
            "device_map": self.device_map
        } 