#!/bin/bash

# Path to the YAML configuration file
CONFIG_FILE="config.yaml"

# Check if yq is installed
if ! command -v yq > /dev/null; then
  echo "yq is not installed. Please install it using 'sudo apt-get install yq' or another method."
  exit 1
fi

# Loop through each tool in the YAML file
tool_count=$(yq -r '.asdf.tools | length' "$CONFIG_FILE")

for (( i=0; i<$tool_count; i++ )); do
  PLUGIN_NAME=$(yq -r ".asdf.tools[$i].name" "$CONFIG_FILE")
  PLUGIN_GIT=$(yq -r ".asdf.tools[$i].git" "$CONFIG_FILE")
  DEFAULT_VERSION=$(yq -r ".asdf.tools[$i].default" "$CONFIG_FILE")
  VERSION_COUNT=$(yq -r ".asdf.tools[$i].versions | length" "$CONFIG_FILE")
  echo "======================================= asdf setup: $PLUGIN_NAME ======================================="
  
  echo "Processing plugin: $PLUGIN_NAME"
  # Step 1: Add the plugin
  if ! asdf plugin-list | grep -q "$PLUGIN_NAME"; then
    echo "Adding plugin $PLUGIN_NAME from $PLUGIN_GIT"
    asdf plugin-add "$PLUGIN_NAME" "$PLUGIN_GIT"
  else
    echo "Plugin $PLUGIN_NAME already added."
  fi

  # Step 2: Install specified versions
  for (( j=0; j<$VERSION_COUNT; j++ )); do
    VERSION=$(yq -r ".asdf.tools[$i].versions[$j]" "$CONFIG_FILE")
    # Check if the version is already installed
    if asdf list "$PLUGIN_NAME" | grep -q "^$VERSION\$"; then
      echo "Version $VERSION for plugin $PLUGIN_NAME is already installed."
    else
      echo "Installing version $VERSION for plugin $PLUGIN_NAME"
      asdf install "$PLUGIN_NAME" "$VERSION"
    fi
  done

  # Step 3: Set the default global version if specified
  if [ -n "$DEFAULT_VERSION" ]; then
    echo "Setting global default version $DEFAULT_VERSION for plugin $PLUGIN_NAME"
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
    echo "No default global version specified for plugin $PLUGIN_NAME, skipping..."
  fi

  echo "Finished processing plugin: $PLUGIN_NAME"
  echo ""
done