#!/bin/bash

# Simple Script Runner with Arrow Keys and Enter
# Only uses arrow keys for navigation and Enter to run scripts

# Define the directory containing the scripts
SCRIPT_DIR="scripts"

# Define colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Highlight color for the selected item
HIGHLIGHT_BG='\033[44m' # Blue background

# Function to print a separator
print_separator() {
  echo -e "${MAGENTA}==================================================================================================${RESET}"
}

# Function to execute a script
execute_script() {
  local script_path=$1
  print_separator
  echo -e "${GREEN}Executing $script_path...${RESET}"
  bash "$script_path"
  local exit_code=$?
  echo -e "${GREEN}Finished executing $script_path (Exit code: $exit_code).${RESET}"
  print_separator
  return $exit_code
}

# Check if the script directory exists
if [ ! -d "$SCRIPT_DIR" ]; then
  echo -e "${RED}Error: Directory '$SCRIPT_DIR' does not exist.${RESET}"
  exit 1
fi

# Find all scripts
SCRIPT_FILES=($(find "$SCRIPT_DIR" -type f -name "*.sh" | sort -V))

# Check if any scripts were found
if [ ${#SCRIPT_FILES[@]} -eq 0 ]; then
  echo -e "${RED}No scripts found in '$SCRIPT_DIR'.${RESET}"
  exit 1
fi

# Arrays to hold script info
SCRIPT_PATHS=("${SCRIPT_FILES[@]}")
SCRIPT_NAMES=()
SCRIPT_DESCRIPTIONS=()

# Make sure scripts are executable
chmod +x "${SCRIPT_PATHS[@]}" 2>/dev/null

# Load script information (name and description)
echo -e "${BLUE}Loading script information...${RESET}"
for SCRIPT_PATH in "${SCRIPT_PATHS[@]}"; do
  # Extract just the filename for display
  SCRIPT_NAME=$(basename "$SCRIPT_PATH")
  SCRIPT_NAMES+=("$SCRIPT_NAME")
  
  # Retrieve the multiline description from the script
  SCRIPT_DESCRIPTION=$(awk '/^DESCRIPTION="""/,/^"""/' "$SCRIPT_PATH" 2>/dev/null | sed '1d;$d')
  
  # Check if a description was found
  if [ -z "$SCRIPT_DESCRIPTION" ]; then
    SCRIPT_DESCRIPTION="No description available."
  fi
  
  # Store the description in the array
  SCRIPT_DESCRIPTIONS+=("$SCRIPT_DESCRIPTION")
done

# Function to display the menu with the current selection highlighted
display_menu() {
  local selected=$1
  local start_index=0
  local max_display=5
  local menu_size=${#SCRIPT_NAMES[@]}

  # Calculate start index for scrolling if needed
  if [ $selected -gt $(($max_display - 2)) ] && [ $menu_size -gt $max_display ]; then
    start_index=$(($selected - $max_display + 2))
    if [ $start_index -gt $(($menu_size - $max_display)) ]; then
      start_index=$(($menu_size - $max_display))
    fi
    if [ $start_index -lt 0 ]; then
      start_index=0
    fi
  fi

  clear
  echo -e "${CYAN}${BOLD}=== SCRIPT RUNNER MENU ===${RESET}"
  echo -e "${CYAN}Use UP/DOWN arrow keys to navigate, ENTER to run a script, q to quit${RESET}"
  echo

  # Display scripts with scrolling
  for i in $(seq $start_index $(($start_index + $max_display - 1))); do
    if [ $i -lt $menu_size ]; then
      # Display script entry
      if [ $i -eq $selected ]; then
        echo -e "${HIGHLIGHT_BG}${BOLD}[$((i+1))] ${SCRIPT_NAMES[$i]}${RESET}"
        
        # Show full description for selected item with highlighting
        echo -e "${SCRIPT_DESCRIPTIONS[$i]}" | while IFS= read -r line; do
          echo -e "${HIGHLIGHT_BG}    $line${RESET}"
        done
      else
        echo -e "${YELLOW}[$((i+1))] ${SCRIPT_NAMES[$i]}${RESET}"
        
        # Show full description
        echo -e "${SCRIPT_DESCRIPTIONS[$i]}" | while IFS= read -r line; do
          echo -e "${GREEN}    $line${RESET}"
        done
      fi
      echo
    fi
  done
  
  # Show scroll indicators if needed
  if [ $menu_size -gt $max_display ]; then
    if [ $start_index -gt 0 ]; then
      echo -e "${BLUE}↑ More scripts above${RESET}"
    fi
    if [ $(($start_index + $max_display)) -lt $menu_size ]; then
      echo -e "${BLUE}↓ More scripts below${RESET}"
    fi
  fi
}

# Reset terminal on exit
reset_terminal() {
  tput rmcup  # Restore screen
  stty echo   # Turn echo back on
  stty icanon # Turn canonical mode back on
}

# Set up terminal for arrow key input
setup_terminal() {
  tput smcup  # Save screen
  stty -echo  # Turn echo off
  stty -icanon # Turn canonical mode off
}

# Trap to ensure terminal is reset on exit
trap reset_terminal EXIT INT TERM

# Enable arrow key navigation
setup_terminal

# Main loop for the interactive menu
selected=0
total_options=${#SCRIPT_NAMES[@]}

while true; do
  # Display menu with current selection
  display_menu $selected
  
  # Read a keypress (raw mode)
  IFS= read -r -n1 key
  
  # Handle special keys
  if [[ $key == $'\e' ]]; then
    # It's an escape sequence
    read -r -n2 -t 0.01 rest
    
    if [[ $rest == '[A' ]]; then  # Up arrow
      # Move selection up
      ((selected--))
      if [ $selected -lt 0 ]; then
        selected=$((total_options - 1))
      fi
    elif [[ $rest == '[B' ]]; then  # Down arrow
      # Move selection down
      ((selected++))
      if [ $selected -ge $total_options ]; then
        selected=0
      fi
    fi
  elif [[ $key == '' ]]; then  # Enter key
    # Execute selected script without confirmation
    clear
    echo -e "${CYAN}${BOLD}=== EXECUTING SCRIPT ===${RESET}"
    echo -e "${YELLOW}Selected: ${SCRIPT_NAMES[$selected]}${RESET}"
    print_separator
    
    # Reset terminal temporarily for script execution
    reset_terminal
    
    # Execute the script
    execute_script "${SCRIPT_PATHS[$selected]}"
    
    echo -e "${CYAN}Press any key to return to menu...${RESET}"
    read -n1
    
    # Set up terminal again for navigation
    setup_terminal
  elif [[ $key == 'q' || $key == 'Q' ]]; then  # Quit
    break
  fi
done

# Clean exit
clear
echo -e "${GREEN}Exiting script runner. Goodbye!${RESET}"
exit 0