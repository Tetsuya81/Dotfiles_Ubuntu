#!/bin/bash

# Installation script for various tools (broot, btop, starship, superfile)

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

# Check if Homebrew is available
if ! command -v brew &>/dev/null; then
  echo -e "${YELLOW}Homebrew is not installed. Some tools might not be installed correctly.${NC}"
  echo -e "${YELLOW}Consider running the brew.sh script first.${NC}"
  
  # Exit if in dry run mode as we'll just show a bunch of error messages
  if [[ "$DRY_RUN" == "true" ]]; then
    echo -e "${YELLOW}Exiting dry run as Homebrew is required for this script.${NC}"
    exit 0
  fi
fi

# Install broot file manager
install_broot() {
  print_header "Installing broot file manager"
  
  if command -v broot &>/dev/null; then
    echo -e "${GREEN}broot is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: brew install broot"
    else
      echo "Installing broot..."
      brew install broot
      
      # Initialize broot
      mkdir -p ~/.config/broot
      
      echo -e "${GREEN}broot installed successfully!${NC}"
    fi
  fi
}

# Install btop system monitor
install_btop() {
  print_header "Installing btop system monitor"
  
  if command -v btop &>/dev/null; then
    echo -e "${GREEN}btop is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: brew install btop"
    else
      echo "Installing btop..."
      brew install btop
      
      echo -e "${GREEN}btop installed successfully!${NC}"
    fi
  fi
}

# Install starship prompt
install_starship() {
  print_header "Installing starship prompt"
  
  if command -v starship &>/dev/null; then
    echo -e "${GREEN}starship is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: curl -sS https://starship.rs/install.sh | sh -s -- -y"
      echo "Would add starship init to ~/.bashrc if needed"
    else
      echo "Installing starship..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y
      
      # Add to .bashrc if not already there
      if ! grep -q "eval \"\$(starship init bash)\"" "$HOME/.bashrc"; then
        echo 'eval "$(starship init bash)"' >> "$HOME/.bashrc"
      fi
      
      # Create config directory
      mkdir -p "$HOME/.config"
      
      echo -e "${GREEN}starship installed successfully!${NC}"
    fi
  fi
}

# Install superfile file manager
install_superfile() {
  print_header "Installing superfile file manager"
  
  if command -v superfile &>/dev/null; then
    echo -e "${GREEN}superfile is already installed.${NC}"
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: npm install -g superfile"
    else
      # Check if npm is available
      if ! command -v npm &>/dev/null; then
        echo -e "${YELLOW}npm is not installed. Will not install superfile.${NC}"
        echo -e "${YELLOW}Consider running the volta-claude.sh script first.${NC}"
        return 1
      fi
      
      echo "Installing superfile..."
      npm install -g superfile
      
      # Create config directory
      mkdir -p "$HOME/.config/superfile"
      
      echo -e "${GREEN}superfile installed successfully!${NC}"
    fi
  fi
}

# Main function to install all tools
main() {
  install_broot
  install_btop
  install_starship
  install_superfile
  
  echo -e "\n${GREEN}Tool installation completed!${NC}"
}

# Run the main function
main