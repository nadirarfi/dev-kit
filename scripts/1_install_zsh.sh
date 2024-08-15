#!/bin/bash

DESCRIPTION="""
This script installs Zsh, Oh My Zsh, only if they are not already installed on the system.

Key steps:
1. Installs Zsh if it's not present, and sets it as the default shell if it isn't already.
2. Installs Oh My Zsh if it is not already installed.

Use this script to efficiently set up your shell environment with Zsh, Oh My Zsh.
"""


# https://github.com/ohmyzsh/ohmyzsh/wiki/Installing-ZSH
# Check if Zsh is installed
if ! command -v zsh > /dev/null; then
  echo "Zsh is not installed. Installing Zsh..."
  sudo apt install zsh
  zsh --version
else
  echo "Zsh is already installed."
fi

# Check if Zsh is the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Setting Zsh as the default shell..."
  sudo chsh -s $(which zsh)
else
  echo "Zsh is already the default shell."
fi

# Check if Oh My Zsh is installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
  echo "Oh My Zsh is already installed."
fi
