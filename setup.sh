#!/bin/bash

# Define the directory containing the scripts
SCRIPT_DIR="scripts"

# Retrieve the names of all files in the directory and store them in an array
SCRIPT_PATHS=($(ls -1 "$SCRIPT_DIR"))

# Function to print a separator
print_separator() {
  echo -e "${MAGENTA}==================================================================================================${RESET}"
}

# Array to hold descriptions
SCRIPT_DESCRIPTIONS=()

# Iterate over each script to gather descriptions
for SCRIPT_NAME in "${SCRIPT_PATHS[@]}"; do
  SCRIPT_PATH=$SCRIPT_DIR/$SCRIPT_NAME
  # Retrieve the multiline description from the script
  SCRIPT_DESCRIPTION=$(awk '/^DESCRIPTION="""/,/^"""/' "$SCRIPT_PATH" | sed '1d;$d')
  # Check if a description was found
  if [ -z "$SCRIPT_DESCRIPTION" ]; then
    SCRIPT_DESCRIPTION="No description available."
  fi
  # Store the description in the array
  SCRIPT_DESCRIPTIONS+=("$SCRIPT_DESCRIPTION")
done
# Print all scripts and their descriptions
echo -e "${CYAN}List of Scripts and their Descriptions:${RESET}"
for i in "${!SCRIPT_PATHS[@]}"; do
  echo -e "${YELLOW}Script $((i + 1)): ${SCRIPT_PATHS[$i]}${RESET}"
  echo -e "${GREEN}${SCRIPT_DESCRIPTIONS[$i]}${RESET}"
  print_separator
done



# Prompt the user to ask if they want to run all scripts
echo -e "${CYAN}"
read -p "Do you want to run all scripts automatically? (y/n): " run_all

# If the user chooses to run all scripts
if [[ "$run_all" == "y" ]]; then
  for SCRIPT_NAME in "${SCRIPT_PATHS[@]}"; do
    SCRIPT_PATH=$SCRIPT_DIR/$SCRIPT_NAME
    print_separator
    echo -e "${GREEN}Executing $SCRIPT_PATH...${RESET}"
    bash "$SCRIPT_PATH"
    echo -e "${GREEN}Finished executing $SCRIPT_PATH.${RESET}"
    echo
    print_separator
  done
  echo -e "${BLUE}All scripts have been executed.${RESET}"
else
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
      print_separator
      echo -e "${MAGENTA}Description for $SCRIPT_PATH:${RESET}"
      echo -e "${GREEN}$SCRIPT_DESCRIPTION${RESET}"
      print_separator
      print_separator

      # Ask the user if they want to execute the script
      echo -e "${CYAN}"
      read -p "Do you want to execute this script? (y/n): " user_response

      if [[ "$user_response" == "y" ]]; then
        echo -e "${GREEN}Executing $SCRIPT_PATH...${RESET}"
        bash "$SCRIPT_PATH"
      else
        echo -e "${YELLOW}Skipping $SCRIPT_PATH.${RESET}"
      fi

      # Add a pause before moving on to the next script
      echo -e "${MAGENTA}"
      read -p "Press enter to continue to the next script..."
    fi
  done
fi
