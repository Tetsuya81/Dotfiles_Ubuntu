#!/bin/bash

# Miniforge3 installation script for Ubuntu

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/install.sh" --source-only 2>/dev/null || {
  # Colors for output
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;34m"
  NC="\033[0m" # No Color
  
  # Print header function
  print_header() {
    echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}\n"
  }
  
  # Dry run flag
  DRY_RUN=false
  if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}Running in dry run mode. No changes will be made.${NC}"
  fi
}

print_header "Installing Miniforge3"

MINIFORGE_DIR="$HOME/miniforge3"
MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

# Check if Miniforge3 is already installed
if [[ -d "$MINIFORGE_DIR" ]] && [[ -x "$MINIFORGE_DIR/bin/conda" ]]; then
  echo -e "${GREEN}Miniforge3 is already installed.${NC}"
  
  if [[ "$DRY_RUN" == "false" ]]; then
    echo "Updating conda..."
    "$MINIFORGE_DIR/bin/conda" update -n base conda -y
  else
    echo "Would run: $MINIFORGE_DIR/bin/conda update -n base conda -y"
  fi
  
  exit 0
fi

# Download and install Miniforge3
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Would download Miniforge3 from: $MINIFORGE_URL"
  echo "Would install Miniforge3 to: $MINIFORGE_DIR"
else
  echo "Downloading Miniforge3..."
  TEMP_DIR="$(mktemp -d)"
  INSTALLER_PATH="$TEMP_DIR/miniforge.sh"
  
  curl -fsSL "$MINIFORGE_URL" -o "$INSTALLER_PATH"
  
  echo "Installing Miniforge3..."
  bash "$INSTALLER_PATH" -b -p "$MINIFORGE_DIR" || {
    echo -e "${RED}Failed to install Miniforge3.${NC}"
    rm -rf "$TEMP_DIR"
    exit 1
  }
  
  rm -rf "$TEMP_DIR"
  
  # Initialize conda for bash
  "$MINIFORGE_DIR/bin/conda" init bash
  
  # Update base conda
  "$MINIFORGE_DIR/bin/conda" update -n base conda -y
  
  # Disable auto-activation of base environment
  "$MINIFORGE_DIR/bin/conda" config --set auto_activate_base false
  
  echo -e "${GREEN}Miniforge3 installed successfully!${NC}"
  echo -e "${YELLOW}Please restart your shell or run 'source ~/.bashrc' to start using conda.${NC}"
fi