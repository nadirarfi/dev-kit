#!/bin/bash

DESCRIPTION="""
This script automates the creation and setup of an SSH key for GitHub.

Key steps:
1. Creates the .ssh directory if it doesn't exist.
2. Generates a new SSH key pair using the provided email.
3. Starts the SSH agent and adds the new key.
4. Copies the public key to the clipboard (using xclip if available).
5. Provides instructions for adding the public key to your GitHub account.

Use this script to quickly set up SSH authentication for GitHub.
"""


CONFIG_FILE="config.yaml"

# Read value from ENV variable
EMAIL=$EMAIL_ADDRESS

# Variables
KEY_NAME=github_ssh_key
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"
PUBLIC_KEY_PATH="$KEY_PATH.pub"

# Check if the .ssh directory exists, create it if not
if [ ! -d "$SSH_DIR" ]; then
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
fi

# Generate SSH key
ssh-keygen -t rsa -C "$EMAIL" -f "$KEY_PATH" -N ""

# Start the ssh-agent if not already running
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi

# Add the SSH key to the ssh-agent
ssh-add "$KEY_PATH"

# Copy the SSH public key to clipboard using xclip
if command -v xclip > /dev/null; then
  xclip -selection clipboard < "$PUBLIC_KEY_PATH"
  echo "Public key copied to clipboard using xclip."
else
  echo "xclip not found. Please install it or copy the public key manually:"
  cat "$PUBLIC_KEY_PATH"
fi

# Final instructions
echo "SSH key generated and added to the SSH agent."
echo "Please add the following public key to your GitHub account:"
cat "$PUBLIC_KEY_PATH"

# Instructions to GitHub
echo "Visit: https://github.com/settings/ssh/new"
