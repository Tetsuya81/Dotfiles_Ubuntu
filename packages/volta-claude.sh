#!/bin/bash

# Installation script for Volta (JavaScript tools) and Claude Code

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

# Install Volta
install_volta() {
  print_header "Installing Volta (JavaScript toolchain)"
  
  # Check if Volta is already installed
  if command -v volta &>/dev/null; then
    echo -e "${GREEN}Volta is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: curl https://get.volta.sh | bash"
    else
      echo "Installing Volta..."
      curl https://get.volta.sh | bash
      
      # Source Volta in current shell
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
      
      echo -e "${GREEN}Volta installed successfully!${NC}"
    fi
  fi
  
  # Install Node.js and npm using Volta
  if command -v volta &>/dev/null; then
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: volta install node"
      echo "Would run: volta install npm"
    else
      echo "Installing Node.js using Volta..."
      volta install node
      
      echo "Installing npm using Volta..."
      volta install npm
    fi
  fi
}

# Install Claude Code
install_claude_code() {
  print_header "Installing Claude Code"
  
  # Check if Claude Code is already installed
  if command -v claude &>/dev/null; then
    echo -e "${GREEN}Claude Code is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: npm install -g @anthropic-ai/claude-code-cli"
    else
      # Check if npm is available
      if ! command -v npm &>/dev/null; then
        echo -e "${RED}npm is not installed. Cannot install Claude Code.${NC}"
        return 1
      fi
      
      echo "Installing Claude Code..."
      npm install -g @anthropic-ai/claude-code-cli
      
      echo -e "${GREEN}Claude Code installed successfully!${NC}"
      echo -e "${YELLOW}To configure Claude Code, run: claude configure${NC}"
    fi
  fi
}

# Main function
main() {
  install_volta
  install_claude_code
  
  echo -e "\n${GREEN}Volta and Claude Code installation completed!${NC}"
  echo -e "${YELLOW}Note: You may need to restart your shell to use Volta and Claude Code.${NC}"
}

# Run the main function
main