#!/bin/bash

# GitHub CLI installation script for Ubuntu

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

print_header "Installing GitHub CLI"

# Check if GitHub CLI is already installed
if command -v gh &>/dev/null; then
  echo -e "${GREEN}GitHub CLI is already installed.${NC}"
  exit 0
fi

# Install GitHub CLI
if [[ "$DRY_RUN" == "true" ]]; then
  # Check if we would use brew or apt
  if command -v brew &>/dev/null; then
    echo "Would run: brew install gh"
  else
    echo "Would run: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "Would run: sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "Would run: echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    echo "Would run: sudo apt update"
    echo "Would run: sudo apt install gh -y"
  fi
else
  echo "Installing GitHub CLI..."
  
  # Use Homebrew if available, otherwise use official package
  if command -v brew &>/dev/null; then
    brew install gh
  else
    # Install GitHub CLI from official package
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    sudo apt update
    sudo apt install gh -y
  fi
  
  echo -e "${GREEN}GitHub CLI installed successfully!${NC}"
  echo -e "${YELLOW}To authenticate with GitHub, run 'gh auth login'${NC}"
fi