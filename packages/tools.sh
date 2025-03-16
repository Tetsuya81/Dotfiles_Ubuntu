#!/bin/bash

# Installation script for various tools (broot, btop, starship, superfile)

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

# Check if Homebrew is available
if ! command_exists brew; then
  log_warning "Homebrew is not installed. Some tools might not be installed correctly."
  log_warning "Consider running the brew.sh script first."
  
  # Exit if in dry run mode as we'll just show a bunch of error messages
  if [[ "$DRY_RUN" == "true" ]]; then
    log_warning "Exiting dry run as Homebrew is required for this script."
    exit 0
  fi
fi

# Install broot file manager
install_broot() {
  print_header "Installing broot file manager"
  
  if command_exists broot; then
    log_info "broot is already installed."
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: brew install broot"
    else
      echo "Installing broot..."
      # Source brew environment variables in case they're not in the current environment
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || $HOME/.linuxbrew/bin/brew shellenv 2>/dev/null)"
      brew install broot
      
      # Initialize broot
      mkdir -p ~/.config/broot
      
      log_info "broot installed successfully!"
    fi
  fi
}

# Install btop system monitor
install_btop() {
  print_header "Installing btop system monitor"
  
  if command_exists btop; then
    log_info "btop is already installed."
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: brew install btop"
    else
      echo "Installing btop..."
      # Source brew environment variables
      eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv 2>/dev/null || $HOME/.linuxbrew/bin/brew shellenv 2>/dev/null)"
      brew install btop
      
      log_info "btop installed successfully!"
    fi
  fi
}

# Install starship prompt
install_starship() {
  print_header "Installing starship prompt"
  
  if command_exists starship; then
    log_info "starship is already installed."
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
      
      log_info "starship installed successfully!"
    fi
  fi
}

# Install superfile file manager
install_superfile() {
  print_header "Installing superfile file manager"
  
  if command_exists superfile; then
    log_info "superfile is already installed."
  else
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: npm install -g superfile"
    else
      # Check if npm is available
      if ! command_exists npm; then
        log_warning "npm is not installed. Will not install superfile."
        log_warning "Consider running the volta-claude.sh script first."
        return 1
      fi
      
      echo "Installing superfile..."
      npm install -g superfile
      
      # Create config directory
      mkdir -p "$HOME/.config/superfile"
      
      log_info "superfile installed successfully!"
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
