#!/bin/bash

DESCRIPTION="""
This script configures and verifies SSH access to GitHub.

Key steps:
1. Adds GitHub SSH configuration to your SSH config file if missing.
2. Checks for the existence of the specified SSH key.
3. Starts the SSH agent and adds your key if not already added.
4. Tests the SSH connection to GitHub and provides feedback.

Use this script to automate and validate your SSH setup for GitHub.
"""

# Variables
KEY_NAME=github_ssh_key
SSH_KEY_PATH="$HOME/.ssh/$KEY_NAME"
SSH_CONFIG_FILE="$HOME/.ssh/config"
GITHUB_HOST="github.com"

# Step 1: Ensure SSH configuration for GitHub exists
echo "Configuring SSH for GitHub..."

if grep -Fxq "Host $GITHUB_HOST" "$SSH_CONFIG_FILE"; then
  echo "SSH configuration for GitHub already exists in $SSH_CONFIG_FILE."
else
  echo "Adding SSH configuration for GitHub to $SSH_CONFIG_FILE."
  cat >> "$SSH_CONFIG_FILE" <<EOL

# GitHub SSH configuration
Host github.com
    HostName github.com
    User git
    IdentityFile $SSH_KEY_PATH
EOL
  echo "SSH configuration for GitHub added to $SSH_CONFIG_FILE."
fi

# Step 2: Check if SSH key exists, prompt user if not
if [ ! -f "$SSH_KEY_PATH" ]; then
  echo "SSH key not found at $SSH_KEY_PATH."
  echo "Please generate an SSH key using ssh-keygen and try again."
  exit 1
fi

# Step 3: Start SSH agent if not running and add the key
echo "Starting the SSH agent and adding your SSH key..."
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)"
fi

ssh-add "$SSH_KEY_PATH"

# Step 4: Test the SSH connection to GitHub
echo "Testing SSH connection to GitHub..."
ssh -T git@$GITHUB_HOST

# Step 6: Provide feedback based on the result of the connection test
if [ $? -eq 1 ]; then
  echo "SSH connection to GitHub failed. Please check your SSH key and configuration."
  exit 1
elif [ $? -eq 255 ]; then
  echo "SSH connection to GitHub could not be established."
  echo "You might have to confirm the authenticity of the host."
  exit 1
else
  echo "SSH connection to GitHub was successful!"
fi