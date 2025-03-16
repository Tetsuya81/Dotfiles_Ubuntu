#!/bin/bash

# Installation script for Volta (JavaScript tools) and Claude Code

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

# Install Volta
install_volta() {
  print_header "Installing Volta (JavaScript toolchain)"
  
  # Check if Volta is already installed
  if command_exists volta; then
    log_info "Volta is already installed."
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: curl https://get.volta.sh | bash"
    else
      echo "Installing Volta..."
      curl https://get.volta.sh | bash
      
      # Source Volta in current shell
      export VOLTA_HOME="$HOME/.volta"
      export PATH="$VOLTA_HOME/bin:$PATH"
      
      log_info "Volta installed successfully!"
    fi
  fi
  
  # Install Node.js and npm using Volta
  if command_exists volta; then
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
  if command_exists claude; then
    log_info "Claude Code is already installed."
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: npm install -g @anthropic-ai/claude-code-cli"
    else
      # Check if npm is available
      if ! command_exists npm; then
        log_error "npm is not installed. Cannot install Claude Code."
        return 1
      fi
      
      echo "Installing Claude Code..."
      npm install -g @anthropic-ai/claude-code-cli
      
      log_info "Claude Code installed successfully!"
      log_warning "To configure Claude Code, run: claude configure"
    fi
  fi
}

# Main function
main() {
  install_volta
  install_claude_code
  
  log_info "Volta and Claude Code installation completed!"
  log_warning "Note: You may need to restart your shell to use Volta and Claude Code."
}

# Run the main function
main
