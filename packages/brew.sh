#!/bin/bash

# Homebrew installation script for Ubuntu

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

print_header "Installing Homebrew"

# Check if Homebrew is already installed
if command_exists brew; then
  log_info "Homebrew is already installed."
  
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
    log_error "Failed to install Homebrew."
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
    log_warning "Homebrew installation directory not found."
    echo "Please manually add Homebrew to your PATH if needed."
  fi
  
  log_info "Homebrew installed successfully!"
fi
