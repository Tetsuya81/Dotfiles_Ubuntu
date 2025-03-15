#!/bin/bash

# Dotfiles Symbolic Link Creation Script
# This script creates symbolic links from the dotfiles to the appropriate locations

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="$DOTFILES_DIR/config"

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
  echo -e "${YELLOW}Running in dry run mode. No links will be created.${NC}"
fi

# Print header function
print_header() {
  echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}\n"
}

# Function to create a symbolic link
create_link() {
  local src="$1"
  local dest="$2"
  local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
  
  # Check if destination already exists
  if [[ -e "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      local current_target="$(readlink "$dest")"
      if [[ "$current_target" == "$src" ]]; then
        echo -e "${GREEN}✓${NC} Link already exists: $dest -> $src"
        return 0
      fi
    fi
    
    # Backup existing file/directory
    echo -e "${YELLOW}!${NC} Backing up existing file: $dest"
    if [[ "$DRY_RUN" == "false" ]]; then
      mkdir -p "$backup_dir"
      mv "$dest" "$backup_dir/"
    else
      echo "  Would back up to: $backup_dir"
    fi
  fi
  
  # Create parent directory if it doesn't exist
  local parent_dir="$(dirname "$dest")"
  if [[ ! -d "$parent_dir" ]]; then
    echo -e "${BLUE}i${NC} Creating directory: $parent_dir"
    if [[ "$DRY_RUN" == "false" ]]; then
      mkdir -p "$parent_dir"
    fi
  fi
  
  # Create symbolic link
  echo -e "${GREEN}+${NC} Creating link: $dest -> $src"
  if [[ "$DRY_RUN" == "false" ]]; then
    ln -sf "$src" "$dest"
  fi
}

# Link bash configuration files
link_bash() {
  print_header "Linking Bash configuration files"
  
  create_link "$CONFIG_DIR/bash/.bashrc" "$HOME/.bashrc"
  create_link "$CONFIG_DIR/bash/.bash_aliases" "$HOME/.bash_aliases"
}

# Link helix configuration files
link_helix() {
  print_header "Linking Helix configuration files"
  
  create_link "$CONFIG_DIR/helix/config.toml" "$HOME/.config/helix/config.toml"
}

# Link superfile configuration
link_superfile() {
  print_header "Linking Superfile configuration files"
  
  create_link "$CONFIG_DIR/superfile/config.toml" "$HOME/.config/superfile/config.toml"
}

# Link starship configuration
link_starship() {
  print_header "Linking Starship configuration files"
  
  create_link "$CONFIG_DIR/starship/starship.toml" "$HOME/.config/starship.toml"
}

# Main function
main() {
  print_header "Creating symbolic links for dotfiles"
  
  link_bash
  link_helix
  link_superfile
  link_starship
  
  echo -e "\n${GREEN}Symbolic links created successfully!${NC}"
}

# Run the main function
main