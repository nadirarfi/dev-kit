#!/bin/bash

DESCRIPTION="""
This script automates the setup of tools using asdf based on a YAML configuration file.

Key steps:
1. Verifies the installation of 'yq' for parsing the YAML file.
2. Loops through each tool defined in the 'asdf.tools' section of the config file.
3. Adds the specified asdf plugin if not already added.
4. Installs the specified versions of each tool.
5. Sets the global default version for each tool and updates the ~/.zshrc file if applicable.

Use this script to streamline the installation and configuration of development tools with asdf.
"""

# Path to the YAML configuration file
CONFIG_FILE="config.yaml"

# Check if yq is installed
if ! command -v yq > /dev/null; then
  echo -e "${RED}yq is not installed. Please install it using 'sudo apt-get install yq' or another method.${NC}"
  exit 1
fi

# Loop through each tool in the YAML file
tool_count=$(yq -r '.asdf.tools | length' "$CONFIG_FILE")

for (( i=0; i<$tool_count; i++ )); do
  PLUGIN_NAME=$(yq -r ".asdf.tools[$i].name" "$CONFIG_FILE")
  PLUGIN_GIT=$(yq -r ".asdf.tools[$i].git" "$CONFIG_FILE")
  DEFAULT_VERSION=$(yq -r ".asdf.tools[$i].default" "$CONFIG_FILE")
  VERSION_COUNT=$(yq -r ".asdf.tools[$i].versions | length" "$CONFIG_FILE")
  echo -e "${CYAN}======================================= asdf setup: $PLUGIN_NAME =======================================${NC}"
  
  echo -e "${MAGENTA}Processing plugin: $PLUGIN_NAME${NC}"
  
  # Step 1: Add the plugin
  if ! asdf plugin-list | grep -q "$PLUGIN_NAME"; then
    echo -e "${BLUE}Adding plugin $PLUGIN_NAME from $PLUGIN_GIT${NC}"
    asdf plugin-add "$PLUGIN_NAME" "$PLUGIN_GIT"
  else
    echo -e "${GREEN}Plugin $PLUGIN_NAME already added.${NC}"
  fi

  # Step 2: Install specified versions
  for (( j=0; j<$VERSION_COUNT; j++ )); do
    VERSION=$(yq -r ".asdf.tools[$i].versions[$j]" "$CONFIG_FILE")
    # Check if the version is already installed
    if asdf list "$PLUGIN_NAME" | grep -q "^$VERSION\$"; then
      echo -e "${BLUE}Version $VERSION for plugin $PLUGIN_NAME is already installed.${NC}"
    else
      echo -e "${BLUE}Installing version $VERSION for plugin $PLUGIN_NAME${NC}"
      asdf install "$PLUGIN_NAME" "$VERSION"
    fi
  done

  # Step 3: Set the default global version if specified
  if [ -n "$DEFAULT_VERSION" ]; then
    echo -e "${MAGENTA}Setting global default version $DEFAULT_VERSION for plugin $PLUGIN_NAME${NC}"
    asdf global "$PLUGIN_NAME" "$DEFAULT_VERSION"

    # Prepare the line to add to ~/.zshrc
    GLOBAL_COMMAND="asdf global $PLUGIN_NAME $DEFAULT_VERSION"
    
    # Check if an entry already exists in ~/.zshrc and replace it
    if grep -q "^asdf global $PLUGIN_NAME" ~/.zshrc; then
      sed -i "s|^asdf global $PLUGIN_NAME.*|$GLOBAL_COMMAND|" ~/.zshrc
    else
      echo "$GLOBAL_COMMAND" >> ~/.zshrc
    fi
  else
    echo -e "${BLUE}No default global version specified for plugin $PLUGIN_NAME, skipping...${NC}"
  fi

  echo -e "${GREEN}Finished processing plugin: $PLUGIN_NAME${NC}"
  echo ""
done
