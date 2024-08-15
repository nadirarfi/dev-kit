#!/bin/bash

# Path to the YAML configuration file
CONFIG_FILE="config.yaml"

# Check if yq is installed (we'll use it to parse the YAML file)
if ! command -v yq > /dev/null; then
  echo "yq is not installed. Please install it using 'sudo apt-get install yq' or another method."
  exit 1
fi

# Update package lists
echo "Updating package lists..."
sudo apt-get update

# Get the number of packages to install
package_count=$(yq -r '.ubuntu.apt.packages | length' "$CONFIG_FILE")

# Install each package from the config file
for (( i=0; i<$package_count; i++ )); do
  PACKAGE_NAME=$(yq -r ".ubuntu.apt.packages[$i]" "$CONFIG_FILE")
  echo "==============================================================================================="
  echo "Installing package: $PACKAGE_NAME"
  sudo apt-get install -y "$PACKAGE_NAME"
done

echo "All specified packages have been installed."
