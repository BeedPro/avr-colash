#!/bin/bash

# Variables
AVR_PACKAGES=("gcc-avr" "avr-libc" "avrdude")
LOCAL_BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="avr-colash"
CONFIG_FILE=""
LOG_FILE="/tmp/avr-colash/uninstall.log"

# Function to check if a package is installed
check_package() {
  dpkg -s "$1" &> /dev/null
  return $?
}

# Detect the user's shell
USER_SHELL=$(basename "$SHELL")

# Detejmine the appropriate shell configuration file (either .bashrc or .zshrc)
if [ "$USER_SHELL" = "zsh" ]; then
  CONFIG_FILE="$HOME/.zshrc"
elif [ "$USER_SHELL" = "bash" ]; then
  CONFIG_FILE="$HOME/.bashrc"
else
  echo "Unknown shell: $USER_SHELL. Exiting."
  exit 1
fi

# Remove avr-colash from the ~/.local/bin directory
if [ -f "$LOCAL_BIN_DIR/$SCRIPT_NAME" ]; then
  echo "Removing $SCRIPT_NAME from $LOCAL_BIN_DIR..."
  rm "$LOCAL_BIN_DIR/$SCRIPT_NAME"
  if [ $? -eq 0 ]; then
    echo "$SCRIPT_NAME successfully removed."
  else
    echo "Error: Failed to remove $SCRIPT_NAME."
  fi
else
  echo "$SCRIPT_NAME is not installed in $LOCAL_BIN_DIR."
fi

echo "~/.local/bin will not be removed from your PATH."
echo "If you wish to remove it from your PATH please delete it from your $CONFIG_FILE"

echo "AVR tools will not be removed and will need to be removed manually:"
for package in "${AVR_PACKAGES[@]}"; do
    echo "- Please remove $package."
done

# Finish
echo "Uninstallation complete."
echo "If you removed ~/.local/bin from your PATH, remember to run 'source $CONFIG_FILE' or restart your terminal to apply the changes."
