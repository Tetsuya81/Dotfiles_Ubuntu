#!/bin/bash

# Homebrew installation script for Ubuntu

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

print_header "Installing Homebrew"

# Check if Homebrew is already installed
if command -v brew &>/dev/null; then
  echo -e "${GREEN}Homebrew is already installed.${NC}"
  
  if [[ "$DRY_RUN" == "false" ]]; then
    echo "Updating Homebrew..."
    brew update
  else
    echo "Would run: brew update"
  fi
  
  exit 0
fi

# Install Homebrew
if [[ "$DRY_RUN" == "true" ]]; then
  echo "Would run: /bin/bash -c '$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)'"
else
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
    echo -e "${RED}Failed to install Homebrew.${NC}"
    exit 1
  }
  
  # Add Homebrew to PATH
  if [[ -d "/home/linuxbrew/.linuxbrew" ]]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    
    # Add to .bashrc if not already there
    if ! grep -q "eval \"\$(\(/home/linuxbrew/.linuxbrew/bin/brew shellenv\)\)\"" "$HOME/.bashrc"; then
      echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> "$HOME/.bashrc"
    fi
  elif [[ -d "$HOME/.linuxbrew" ]]; then
    eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"
    
    # Add to .bashrc if not already there
    if ! grep -q "eval \"\$(\(\$HOME/.linuxbrew/bin/brew shellenv\)\)\"" "$HOME/.bashrc"; then
      echo 'eval "$("$HOME/.linuxbrew/bin/brew" shellenv)"' >> "$HOME/.bashrc"
    fi
  else
    echo -e "${YELLOW}Warning: Homebrew installation directory not found.${NC}"
    echo "Please manually add Homebrew to your PATH if needed."
  fi
  
  echo -e "${GREEN}Homebrew installed successfully!${NC}"
fi