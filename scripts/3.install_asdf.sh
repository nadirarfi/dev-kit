#!/bin/bash

DESCRIPTION="""
This script installs ASDF version manager, only if it is not already installed on the system.

Key steps:
1. Clones the ASDF repository if ASDF is not installed.

https://asdf-vm.com/guide/getting-started.html

"""

# Check if ASDF is installed
if [ ! -d "$HOME/.asdf" ]; then
  echo -e "${RED}ASDF is not installed. Cloning ASDF repository...${NC}"
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
else
  echo -e "${GREEN}ASDF is already installed.${NC}"
fi

# Check and add ASDF initialization to .zshrc if not present
if ! grep -q '^[^#]*\. "$HOME/.asdf/asdf.sh"' "$HOME/.zshrc"; then
  echo -e "${YELLOW}Adding ASDF initialization to .zshrc...${NC}"
  cat <<EOL >>"$HOME/.zshrc"

################ ASDF
. "\$HOME/.asdf/asdf.sh"
fpath=(\${ASDF_DIR}/completions \$fpath)
autoload -Uz compinit && compinit
EOL
else
  echo -e "${BLUE}ASDF initialization already present in .zshrc.${NC}"
fi
