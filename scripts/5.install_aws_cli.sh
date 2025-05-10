#!/bin/bash
#
# Simple AWS CLI Installation Script for Ubuntu
# This script installs AWS CLI v2 on Ubuntu systems.
#

# Exit immediately if a command exits with a non-zero status
set -e

# Define colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Installing AWS CLI v2 for Ubuntu ===${NC}"

# Step 1: Update package lists
echo -e "${BLUE}Updating package lists...${NC}"
sudo apt update

# Step 2: Install dependencies
echo -e "${BLUE}Installing dependencies...${NC}"
sudo apt install -y unzip curl

# Step 3: Download the AWS CLI v2 installer
echo -e "${BLUE}Downloading AWS CLI installer...${NC}"
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"

# Step 4: Unzip the installer
echo -e "${BLUE}Extracting installation files...${NC}"
unzip -q awscliv2.zip

# Step 5: Run the installer
echo -e "${BLUE}Installing AWS CLI...${NC}"
sudo ./aws/install

# Step 6: Verify the installation
echo -e "${BLUE}Verifying the installation...${NC}"
aws --version

# Step 7: Clean up installation files
echo -e "${BLUE}Cleaning up installation files...${NC}"
rm -rf aws awscliv2.zip

echo -e "${GREEN}AWS CLI v2 has been successfully installed!${NC}"
echo -e "${GREEN}You can now configure AWS CLI by running: aws configure${NC}"