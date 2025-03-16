#!/bin/bash

# Helix editor installation script for Ubuntu

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

print_header "Installing Helix Editor"

# Check if Helix is already installed
if command_exists hx; then
  log_info "Helix is already installed."
  exit 0
fi

# Install Helix
if [[ "$DRY_RUN" == "true" ]]; then
  # Check if we would use brew or apt
  if command_exists brew; then
    echo "Would run: brew install helix"
  else
    echo "Would run: sudo add-apt-repository ppa:maveonair/helix-editor -y"
    # No need to update again, we use the global update function
    echo "Would run: sudo apt install helix -y"
  fi
else
  echo "Installing Helix..."
  
  # Use Homebrew if available, otherwise use PPA
  if command_exists brew; then
    brew install helix
  else
    # Add Helix PPA
    sudo add-apt-repository ppa:maveonair/helix-editor -y
    
    # Only update if not already updated in this session
    if [[ "$SYSTEM_UPDATED" != "true" ]]; then
      sudo apt update
    fi
    
    sudo apt install helix -y
  fi
  
  # Create config directory
  mkdir -p "$HOME/.config/helix"
  
  log_info "Helix installed successfully!"
fi
