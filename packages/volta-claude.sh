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
      
      # Ensure Volta is in .bashrc if not already there
      if ! grep -q "VOLTA_HOME=\"\$HOME/.volta\"" "$HOME/.bashrc"; then
        echo 'export VOLTA_HOME="$HOME/.volta"' >> "$HOME/.bashrc"
        echo 'export PATH="$VOLTA_HOME/bin:$PATH"' >> "$HOME/.bashrc"
      fi
      
      log_info "Volta installed successfully!"
    fi
  fi
  
  # Install Node.js and npm using Volta
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: $HOME/.volta/bin/volta install node"
    echo "Would run: $HOME/.volta/bin/volta install npm"
  else
    echo "Installing Node.js using Volta..."
    # Use full path to ensure we can find volta
    if [[ -f "$HOME/.volta/bin/volta" ]]; then
      "$HOME/.volta/bin/volta" install node
      
      echo "Installing npm using Volta..."
      "$HOME/.volta/bin/volta" install npm
    elif command_exists volta; then
      volta install node
      
      echo "Installing npm using Volta..."
      volta install npm
    else
      log_error "Volta executable not found. PATH may not be properly set."
      return 1
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
      echo "Would run: npm install -g claude-code-cli"
    else
      # Check if npm is available
      if ! command_exists npm; then
        log_error "npm is not installed. Cannot install Claude Code."
        return 1
      fi
      
      # Make sure Volta PATH is available
      if [[ -d "$HOME/.volta/bin" ]]; then
        export VOLTA_HOME="$HOME/.volta"
        export PATH="$VOLTA_HOME/bin:$PATH"
      fi
      
      echo "Installing Claude Code..."
      # パッケージ名が変更されている可能性があるため修正
      npm install -g claude-code-cli || {
        log_warning "Failed to install claude-code-cli, trying alternative package name..."
        npm install -g @anthropic/claude-code || {
          log_warning "Failed to install @anthropic/claude-code, trying original package name..."
          npm install -g @anthropic-ai/claude-code-cli || {
            log_error "Failed to install Claude Code. Package may have been renamed or removed."
            log_info "Please check https://www.npmjs.com/search?q=claude%20code for the current package name."
            return 1
          }
        }
      }
      
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
