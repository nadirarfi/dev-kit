#!/bin/bash


# Define the directory containing the scripts
SCRIPT_DIR="scripts"

# Retrieve the names of all files in the directory and store them in an array
SCRIPT_PATHS=($(ls -1 "$SCRIPT_DIR"))

# Function to print a separator
print_separator() {
  echo -e "${CYAN}================================================================================${RESET}"
}

# Iterate over each script in the directory
for SCRIPT_NAME in "${SCRIPT_PATHS[@]}"; do

  echo -e "${BLUE}Processing script: ${YELLOW}$SCRIPT_NAME${RESET}"

  # Retrieve the multiline description from the script
  SCRIPT_PATH=$SCRIPT_DIR/$SCRIPT_NAME
  SCRIPT_DESCRIPTION=$(awk '/^DESCRIPTION="""/,/^"""/' "$SCRIPT_PATH" | sed '1d;$d')

  # Check if a description was found
  if [ -z "$SCRIPT_DESCRIPTION" ]; then
    echo -e "${RED}No description found in $SCRIPT_PATH.${RESET}"
  else
    # Print the description and the path of the script
    print_separator
    echo -e "${MAGENTA}Description for $SCRIPT_PATH:${RESET}"
    echo -e "${GREEN}$SCRIPT_DESCRIPTION${RESET}"
    print_separator

    # Ask the user if they want to execute the script
    read -p "Do you want to execute this script? (yes/no): " user_response

    if [[ "$user_response" == "yes" ]]; then
      echo -e "${GREEN}Executing $SCRIPT_PATH...${RESET}"
      bash "$SCRIPT_PATH"
    else
      echo -e "${YELLOW}Skipping $SCRIPT_PATH.${RESET}"
    fi

    # Add a pause before moving on to the next script
    echo
    read -p "Press enter to continue to the next script..."
  fi
done
