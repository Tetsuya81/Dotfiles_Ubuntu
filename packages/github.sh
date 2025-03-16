#!/bin/bash

# GitHub CLI installation script for Ubuntu

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

print_header "Installing GitHub CLI"

# Check if GitHub CLI is already installed
if command_exists gh; then
  log_info "GitHub CLI is already installed."
  exit 0
fi

# Install GitHub CLI
if [[ "$DRY_RUN" == "true" ]]; then
  # Check if we would use brew or apt
  if command_exists brew; then
    echo "Would run: brew install gh"
  else
    echo "Would run: curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "Would run: sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg"
    echo "Would run: echo \"deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main\" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null"
    # No need to update again, we use the global update function
    echo "Would run: sudo apt install gh -y"
  fi
else
  echo "Installing GitHub CLI..."
  
  # Use Homebrew if available, otherwise use official package
  if command_exists brew; then
    brew install gh
  else
    # Install GitHub CLI from official package
    curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
    
    # Only update if not already updated in this session
    if [[ "$SYSTEM_UPDATED" != "true" ]]; then
      sudo apt update
    fi
    
    sudo apt install gh -y
  fi
  
  log_info "GitHub CLI installed successfully!"
  log_warning "To authenticate with GitHub, run 'gh auth login'"
fi
