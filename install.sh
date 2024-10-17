#!/bin/bash

# Variables
AVR_PACKAGES=("gcc-avr" "avr-libc" "avrdude")
LOCAL_BIN_DIR="$HOME/.local/bin"
SCRIPT_NAME="avr-colash"
INSTALL_LOG="/tmp/avr-colash/install.log"
REPO_URL="https://github.com/BeedPro/avr-colash.git"  # Change to your actual repo URL
CLONE_DIR="$HOME/Downloads/avr-colash"

# Function to check if a package is installed
check_package() {
  dpkg -s "$1" &> /dev/null
  return $?
}

# Function to check if git is installed
check_git() {
  if ! command -v git &> /dev/null; then
    echo "git is not installed. Please install git."
    exit 1
  else
    echo "git is already installed."
  fi
}

# Clone the repository into ~/Downloads
install_repo() {
  if [ -d "$CLONE_DIR" ]; then
    echo "Repository already exists in $CLONE_DIR. Pulling latest changes..."
    cd "$CLONE_DIR" && git pull
  else
    echo "Cloning repository to $CLONE_DIR..."
    git clone "$REPO_URL" "$CLONE_DIR"
  fi
}

# Detect the user's shell
USER_SHELL=$(basename "$SHELL")

# Determine the appropriate shell configuration file (either .bashrc or .zshrc)
if [ "$USER_SHELL" = "zsh" ]; then
  CONFIG_FILE="$HOME/.zshrc"
elif [ "$USER_SHELL" = "bash" ]; then
  CONFIG_FILE="$HOME/.bashrc"
else
  echo "Unknown shell: $USER_SHELL. Exiting."
  exit 1
fi

# Check if git is installed
check_git

# Clone the repository to ~/Downloads
install_repo

# Install necessary AVR tools
echo "Checking and installing AVR tools..."

for package in "${AVR_PACKAGES[@]}"; do
  if check_package "$package"; then
    echo "$package is already installed."
  else
    echo "Please install $package."
  fi
done

# Create ~/bin if it doesn't exist
if [ ! -d "$LOCAL_BIN_DIR" ]; then
  echo "Creating local bin directory ($LOCAL_BIN_DIR)..."
  mkdir -p "$LOCAL_BIN_DIR"
fi

# Add ~/.local/bin to the PATH if it's not already in the PATH
if [[ ":$PATH:" != *":$LOCAL_BIN_DIR:"* ]]; then
  echo "Adding $LOCAL_BIN_DIR to your PATH in $CONFIG_FILE..."
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$CONFIG_FILE"
  echo "Please restart your terminal or run 'source $CONFIG_FILE' to apply the changes."
fi

# Copy the avr-colash script to ~/bin and make it executable
echo "Installing $SCRIPT_NAME to $LOCAL_BIN_DIR..."
cp "$CLONE_DIR/$SCRIPT_NAME" "$LOCAL_BIN_DIR/"
chmod +x "$LOCAL_BIN_DIR/$SCRIPT_NAME"

# Finish
echo "Installation complete! You can now use 'avr-colash' from anywhere in your terminal."
echo "If you added ~/.local/bin to your PATH, remember to run 'source $CONFIG_FILE' or restart your terminal to apply the changes."
source $CONFIG_FILE
