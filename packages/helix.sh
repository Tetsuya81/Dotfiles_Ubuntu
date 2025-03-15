#!/bin/bash

# Helix editor installation script for Ubuntu

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

print_header "Installing Helix Editor"

# Check if Helix is already installed
if command -v hx &>/dev/null; then
  echo -e "${GREEN}Helix is already installed.${NC}"
  exit 0
fi

# Install Helix
if [[ "$DRY_RUN" == "true" ]]; then
  # Check if we would use brew or apt
  if command -v brew &>/dev/null; then
    echo "Would run: brew install helix"
  else
    echo "Would run: sudo add-apt-repository ppa:maveonair/helix-editor -y"
    echo "Would run: sudo apt update"
    echo "Would run: sudo apt install helix -y"
  fi
else
  echo "Installing Helix..."
  
  # Use Homebrew if available, otherwise use PPA
  if command -v brew &>/dev/null; then
    brew install helix
  else
    # Add Helix PPA
    sudo add-apt-repository ppa:maveonair/helix-editor -y
    sudo apt update
    sudo apt install helix -y
  fi
  
  # Create config directory
  mkdir -p "$HOME/.config/helix"
  
  echo -e "${GREEN}Helix installed successfully!${NC}"
fi