#!/bin/bash

DESCRIPTION="""
This script backs up the user's Zsh configuration (.zshrc) to a specified directory.
It checks if the .zshrc file exists in the user's home directory, and if it does, 
the script creates a backup of this file in a directory named 'configs'. 
The backup is saved as '.myzshrc' within the 'configs' directory.

Key functionalities:
- Verifies the existence of the .zshrc file.
- Creates the 'configs' directory if it doesn't exist.
- Copies the .zshrc file to the 'configs' directory, renaming it to '.myzshrc'.
- Informs the user of the backup's success or if the .zshrc file is missing.
"""

# Define the path to the Zsh configuration file
ZSHRC_PATH="$HOME/.zshrc"

# Define the directory and output file for the Zsh configuration
OUTPUT_DIR="configs"
OUTPUT_FILE="$OUTPUT_DIR/.myzshrc"

# Check if the .zshrc file exists
if [ -f "$ZSHRC_PATH" ]; then
  echo "Retrieving your current Zsh configuration..."

  # Create the output directory if it doesn't exist
  mkdir -p "$OUTPUT_DIR"

  # Copy the contents of .zshrc to the output file
  cp "$ZSHRC_PATH" "$OUTPUT_FILE"
  echo "Your current Zsh configuration has been saved to $OUTPUT_FILE."

else
  echo "No .zshrc file found in your home directory."
fi
