import os
import sys
import logging
from pathlib import Path
from typing import Dict, Any

import torch
from transformers import (
    AutoModelForCausalLM,
    AutoTokenizer,
    TrainingArguments,
    Trainer,
    DataCollatorForLanguageModeling
)
from peft import (
    LoraConfig,
    get_peft_model,
    prepare_model_for_kbit_training
)
from datasets import load_dataset
import wandb

# Add the parent directory to the path to import the config
sys.path.append(str(Path(__file__).parent.parent))
from config.finetune_config import FineTuneConfig

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def setup_wandb(config: FineTuneConfig) -> None:
    """Initialize Weights & Biases for experiment tracking."""
    wandb.init(
        project="adan-finetuning",
        config=config.to_dict(),
        name=f"finetune-{config.base_model.split('/')[-1]}"
    )

def load_model_and_tokenizer(config: FineTuneConfig):
    """Load the base model and tokenizer."""
    logger.info(f"Loading model: {config.base_model}")
    
    # Load tokenizer
    tokenizer = AutoTokenizer.from_pretrained(
        config.base_model,
        trust_remote_code=True
    )
    tokenizer.pad_token = tokenizer.eos_token
    
    # Load model
    model = AutoModelForCausalLM.from_pretrained(
        config.base_model,
        torch_dtype=torch.float16 if config.fp16 else torch.float32,
        device_map=config.device_map,
        trust_remote_code=True
    )
    
    # Prepare model for training
    model = prepare_model_for_kbit_training(model)
    
    # Configure LoRA if enabled
    if config.use_lora:
        logger.info("Configuring LoRA")
        lora_config = LoraConfig(
            r=config.lora_r,
            lora_alpha=config.lora_alpha,
            target_modules=config.lora_target_modules,
            lora_dropout=config.lora_dropout,
            bias="none",
            task_type="CAUSAL_LM"
        )
        model = get_peft_model(model, lora_config)
        model.print_trainable_parameters()
    
    return model, tokenizer

def prepare_dataset(config: FineTuneConfig, tokenizer):
    """Load and prepare the dataset for training."""
    logger.info("Loading dataset")
    
    # Load dataset
    dataset = load_dataset(
        "json",
        data_files={
            "train": config.train_file,
            "validation": config.validation_file
        }
    )
    
    def tokenize_function(examples):
        """Tokenize the examples."""
        return tokenizer(
            examples["text"],
            truncation=True,
            max_length=config.max_seq_length,
            padding="max_length"
        )
    
    # Tokenize dataset
    tokenized_dataset = dataset.map(
        tokenize_function,
        batched=True,
        remove_columns=dataset["train"].column_names
    )
    
    return tokenized_dataset

def train(config: FineTuneConfig):
    """Main training function."""
    # Setup wandb
    setup_wandb(config)
    
    # Load model and tokenizer
    model, tokenizer = load_model_and_tokenizer(config)
    
    # Prepare dataset
    dataset = prepare_dataset(config, tokenizer)
    
    # Configure training arguments
    training_args = TrainingArguments(
        output_dir=config.model_output_dir,
        num_train_epochs=config.num_train_epochs,
        per_device_train_batch_size=config.per_device_train_batch_size,
        gradient_accumulation_steps=config.gradient_accumulation_steps,
        learning_rate=config.learning_rate,
        weight_decay=config.weight_decay,
        warmup_ratio=config.warmup_ratio,
        logging_steps=config.logging_steps,
        logging_dir=config.logging_dir,
        save_steps=config.save_steps,
        save_total_limit=config.save_total_limit,
        evaluation_strategy=config.evaluation_strategy,
        eval_steps=config.eval_steps,
        fp16=config.fp16,
        bf16=config.bf16,
        report_to="wandb"
    )
    
    # Initialize trainer
    trainer = Trainer(
        model=model,
        args=training_args,
        train_dataset=dataset["train"],
        eval_dataset=dataset["validation"],
        data_collator=DataCollatorForLanguageModeling(
            tokenizer=tokenizer,
            mlm=False
        )
    )
    
    # Start training
    logger.info("Starting training")
    trainer.train()
    
    # Save final model
    logger.info("Saving final model")
    trainer.save_model()
    
    # Close wandb
    wandb.finish()

if __name__ == "__main__":
    # Load configuration
    config = FineTuneConfig()
    
    # Create output directories
    os.makedirs(config.model_output_dir, exist_ok=True)
    os.makedirs(config.logging_dir, exist_ok=True)
    
    # Start training
    train(config) 