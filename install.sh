#!/bin/bash

# Ubuntu Server 24.04 Dotfiles Installation Script
# This script installs and configures all necessary packages and tools

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
BLUE="\033[0;34m"
NC="\033[0m" # No Color

# Dry run flag
DRY_RUN=false
if [[ "$1" == "--dry-run" ]]; then
  DRY_RUN=true
  echo -e "${YELLOW}Running in dry run mode. No changes will be made.${NC}"
fi

# Print header function
print_header() {
  echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}\n"
}

# Basic update and install essential packages
update_system() {
  print_header "Updating system packages"
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo apt update"
    echo "Would run: sudo apt upgrade -y"
  else
    sudo apt update
    sudo apt upgrade -y
  fi
}

install_basic_packages() {
  print_header "Installing basic packages"
  
  local packages=("git" "curl" "wget" "build-essential" "pkg-config" \
                  "cmake" "ripgrep" "unzip" "ca-certificates" \
                  "gnupg" "software-properties-common" "zoxide")
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo apt install -y ${packages[*]}"
  else
    sudo apt install -y "${packages[@]}"
  fi
}

# Run all package installation scripts
install_packages() {
  local package_scripts=("brew.sh" "miniforge.sh" "helix.sh" "github.sh" \
                        "tools.sh" "volta-claude.sh" "timedate.sh")
  
  for script in "${package_scripts[@]}"; do
    print_header "Running $script"
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: $DOTFILES_DIR/packages/$script"
    else
      if [[ -x "$DOTFILES_DIR/packages/$script" ]]; then
        bash "$DOTFILES_DIR/packages/$script"
      else
        echo -e "${YELLOW}Warning: $script is not executable. Running with bash.${NC}"
        bash "$DOTFILES_DIR/packages/$script"
      fi
    fi
  done
}

# Create symbolic links
create_symlinks() {
  print_header "Creating symbolic links"
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: $DOTFILES_DIR/link.sh"
  else
    bash "$DOTFILES_DIR/link.sh"
  fi
}

# Main installation process
main() {
  print_header "Starting installation of Dotfiles for Ubuntu Server 24.04"
  
  update_system
  install_basic_packages
  install_packages
  create_symlinks
  
  print_header "Installation complete!"
  echo -e "${GREEN}Dotfiles installation completed successfully!${NC}"
  echo -e "${YELLOW}Note: You may need to restart your shell to apply all changes.${NC}"
}

# Run the main function
main