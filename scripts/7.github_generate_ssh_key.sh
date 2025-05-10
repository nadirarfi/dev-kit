#!/bin/bash

DESCRIPTION="""
This script automates the creation and setup of an SSH key for GitHub.

Key steps:
1. Creates the .ssh directory if it doesn't exist.
2. Generates a new SSH key pair using the provided email if it doesn't already exist.
3. Starts the SSH agent and adds the new key.
4. Copies the public key to the clipboard (using xclip if available).
5. Provides instructions for adding the public key to your GitHub account.

Use this script to quickly set up SSH authentication for GitHub.
"""

# Read value from ENV variable
EMAIL=$EMAIL_ADDRESS

# Variables
KEY_NAME=github_ssh_key
SSH_DIR="$HOME/.ssh"
KEY_PATH="$SSH_DIR/$KEY_NAME"
PUBLIC_KEY_PATH="$KEY_PATH.pub"

# Check if the .ssh directory exists, create it if not
if [ ! -d "$SSH_DIR" ]; then
  echo -e "${YELLOW}Creating .ssh directory...${NC}"
  mkdir -p "$SSH_DIR"
  chmod 700 "$SSH_DIR"
  echo -e "${GREEN}.ssh directory created.${NC}"
fi

# Check if the SSH key already exists
if [ -f "$KEY_PATH" ]; then
  echo -e "${BLUE}SSH key already exists at $KEY_PATH. Skipping key generation.${NC}"
else
  # Generate SSH key
  echo -e "${YELLOW}Generating SSH key...${NC}"
  ssh-keygen -t rsa -C "$EMAIL" -f "$KEY_PATH" -N ""
  echo -e "${GREEN}SSH key generated: $KEY_PATH${NC}"

  # Start the ssh-agent if not already running
  echo -e "${YELLOW}Starting the ssh-agent...${NC}"
  if ! pgrep -u "$USER" ssh-agent >/dev/null; then
    eval "$(ssh-agent -s)"
  fi

  # Add the SSH key to the ssh-agent
  echo -e "${YELLOW}Adding SSH key to ssh-agent...${NC}"
  ssh-add "$KEY_PATH"
  echo -e "${GREEN}SSH key added to ssh-agent.${NC}"

  # Copy the SSH public key to clipboard using xclip
  if command -v xclip >/dev/null; then
    echo -e "${YELLOW}Copying public key to clipboard...${NC}"
    xclip -selection clipboard <"$PUBLIC_KEY_PATH"
    echo -e "${GREEN}Public key copied to clipboard using xclip.${NC}"
  else
    echo -e "${RED}xclip not found. Please install it or copy the public key manually:${NC}"
    cat "$PUBLIC_KEY_PATH"
  fi

  # Final instructions
  echo -e "${BLUE}SSH key generated and added to the SSH agent.${NC}"
  echo -e "${BLUE}Please add the following public key to your GitHub account:${NC}"
  cat "$PUBLIC_KEY_PATH"

fi

# Instructions to GitHub
echo -e "${CYAN}Visit: https://github.com/settings/ssh/new${NC}"
