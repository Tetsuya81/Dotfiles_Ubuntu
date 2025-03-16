#!/bin/bash

# Miniforge3 installation script for Ubuntu

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

print_header "Installing Miniforge3"

MINIFORGE_DIR="$HOME/miniforge3"
MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh"

# Check if Miniforge3 is already installed
if [[ -d "$MINIFORGE_DIR" ]] && [[ -x "$MINIFORGE_DIR/bin/conda" ]]; then
  log_info "Miniforge3 is already installed."
  
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
    log_error "Failed to install Miniforge3."
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
  
  log_info "Miniforge3 installed successfully!"
  log_warning "Please restart your shell or run 'source ~/.bashrc' to start using conda."
fi
