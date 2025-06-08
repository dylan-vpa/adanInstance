#!/usr/bin/env python3
import os
import sys
import argparse
import logging
from pathlib import Path
from huggingface_hub import snapshot_download

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

def download_model(model_name: str, output_dir: str, token: str = None):
    """Download a model from Hugging Face Hub."""
    try:
        logger.info(f"Downloading model: {model_name}")
        logger.info(f"Output directory: {output_dir}")
        
        # Create output directory if it doesn't exist
        os.makedirs(output_dir, exist_ok=True)
        
        # Download model
        snapshot_download(
            repo_id=model_name,
            local_dir=output_dir,
            token=token,
            local_dir_use_symlinks=False
        )
        
        logger.info("Model downloaded successfully!")
        
    except Exception as e:
        logger.error(f"Error downloading model: {e}")
        sys.exit(1)

def main():
    parser = argparse.ArgumentParser(description="Download a model from Hugging Face Hub")
    parser.add_argument("--model", required=True, help="Model name on Hugging Face Hub")
    parser.add_argument("--output", required=True, help="Output directory")
    parser.add_argument("--token", help="Hugging Face token (optional)")
    
    args = parser.parse_args()
    
    # Get token from environment if not provided
    token = args.token or os.getenv("HUGGING_FACE_TOKEN")
    if not token:
        logger.warning("No Hugging Face token provided. Some models may not be accessible.")
    
    download_model(args.model, args.output, token)

if __name__ == "__main__":
    main() 