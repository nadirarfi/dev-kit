#!/bin/bash

# 

DESCRIPTION="""
This script installs ASDF version manager, only if it is not already installed on the system.

Key steps:
1. Clones the ASDF repository if ASDF is not installed.

https://asdf-vm.com/guide/getting-started.html

"""

# Check if ASDF is installed
if [ ! -d "$HOME/.asdf" ]; then
  echo "ASDF is not installed. Cloning ASDF repository..."
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
else
  echo "ASDF is already installed."
fi

# Check and add ASDF initialization to .zshrc if not present
if ! grep -q '^[^#]*\. "$HOME/.asdf/asdf.sh"' "$HOME/.zshrc"; then
  echo "Adding ASDF initialization to .zshrc..."
  cat <<EOL >> "$HOME/.zshrc"

################ ASDF
. "\$HOME/.asdf/asdf.sh"
fpath=(\${ASDF_DIR}/completions \$fpath)
autoload -Uz compinit && compinit
EOL
else
  echo "ASDF initialization already present in .zshrc."
fi