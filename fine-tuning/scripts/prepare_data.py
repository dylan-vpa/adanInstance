import json
import logging
import argparse
from pathlib import Path
from typing import List, Dict, Any
import random

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def load_conversations(file_path: str) -> List[Dict[str, Any]]:
    """Load conversations from a JSON file."""
    with open(file_path, 'r', encoding='utf-8') as f:
        return json.load(f)

def format_conversation(conversation: Dict[str, Any]) -> str:
    """Format a conversation into a single text string."""
    formatted_text = ""
    
    for message in conversation["messages"]:
        role = message["role"]
        content = message["content"]
        
        if role == "system":
            formatted_text += f"System: {content}\n\n"
        elif role == "user":
            formatted_text += f"User: {content}\n\n"
        elif role == "assistant":
            formatted_text += f"Assistant: {content}\n\n"
    
    return formatted_text.strip()

def prepare_dataset(
    input_file: str,
    train_output: str,
    val_output: str,
    val_split: float = 0.1,
    seed: int = 42
):
    """Prepare the dataset for training and validation."""
    logger.info(f"Loading conversations from {input_file}")
    conversations = load_conversations(input_file)
    
    # Shuffle conversations
    random.seed(seed)
    random.shuffle(conversations)
    
    # Split into train and validation
    split_idx = int(len(conversations) * (1 - val_split))
    train_conversations = conversations[:split_idx]
    val_conversations = conversations[split_idx:]
    
    logger.info(f"Total conversations: {len(conversations)}")
    logger.info(f"Training conversations: {len(train_conversations)}")
    logger.info(f"Validation conversations: {len(val_conversations)}")
    
    # Format and save training data
    train_data = [{"text": format_conversation(conv)} for conv in train_conversations]
    with open(train_output, 'w', encoding='utf-8') as f:
        json.dump(train_data, f, ensure_ascii=False, indent=2)
    
    # Format and save validation data
    val_data = [{"text": format_conversation(conv)} for conv in val_conversations]
    with open(val_output, 'w', encoding='utf-8') as f:
        json.dump(val_data, f, ensure_ascii=False, indent=2)
    
    logger.info(f"Saved training data to {train_output}")
    logger.info(f"Saved validation data to {val_output}")

def main():
    parser = argparse.ArgumentParser(description="Prepare dataset for fine-tuning")
    parser.add_argument("--input", required=True, help="Input conversations JSON file")
    parser.add_argument("--train-output", help="Output file for training data")
    parser.add_argument("--val-output", help="Output file for validation data")
    parser.add_argument("--val-split", type=float, default=0.1, help="Validation split ratio")
    parser.add_argument("--seed", type=int, default=42, help="Random seed")
    
    args = parser.parse_args()
    
    # Set default output paths if not provided
    base_dir = Path(__file__).parent.parent
    data_dir = base_dir / "data"
    data_dir.mkdir(parents=True, exist_ok=True)
    
    train_output = args.train_output or str(data_dir / "train.json")
    val_output = args.val_output or str(data_dir / "validation.json")
    
    prepare_dataset(
        input_file=args.input,
        train_output=train_output,
        val_output=val_output,
        val_split=args.val_split,
        seed=args.seed
    )

if __name__ == "__main__":
    main() 