#!/bin/bash

DESCRIPTION="""
This script installs packages on an Ubuntu system based on a YAML configuration file.

Key steps:
1. Checks for the presence of 'yq' (a YAML processor). If missing, prompts for installation.
2. Updates the package lists using 'apt-get update'.
3. Reads the list of packages from the specified YAML configuration file.
4. Installs each package listed under the 'ubuntu.apt.packages' section.

Use this script to automate package installation according to your configuration file.
"""

# Path to the YAML configuration file
CONFIG_FILE="config.yaml"

# Check if yq is installed (we'll use it to parse the YAML file)
if ! command -v yq >/dev/null; then
  echo -e "${RED}yq is not installed. Please install it using 'sudo apt-get install yq' or another method.${NC}"
  exit 1
fi

# Update package lists
echo -e "${CYAN}Updating package lists...${NC}"
sudo apt-get update

# Get the number of packages to install
package_count=$(yq -r '.ubuntu.apt.packages | length' "$CONFIG_FILE")

# Install each package from the config file
for ((i = 0; i < $package_count; i++)); do
  PACKAGE_NAME=$(yq -r ".ubuntu.apt.packages[$i]" "$CONFIG_FILE")
  echo -e "${YELLOW}===============================================================================================${NC}"
  echo -e "${GREEN}Installing package: $PACKAGE_NAME${NC}"
  sudo apt-get install -y "$PACKAGE_NAME"
done

echo -e "${BLUE}All specified packages have been installed.${NC}"
