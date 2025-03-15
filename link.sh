#!/bin/bash

# Dotfiles Symbolic Link Creation Script
# This script creates symbolic links from the dotfiles to the appropriate locations

set -e

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "${SCRIPT_DIR}/utils.sh" ]]; then
  echo "Error: utils.sh not found in ${SCRIPT_DIR}"
  exit 1
fi
source "${SCRIPT_DIR}/utils.sh"

CONFIG_DIR="$DOTFILES_DIR/config"
if [[ ! -d "$CONFIG_DIR" ]]; then
  log_error "Config directory not found: $CONFIG_DIR"
  exit 1
fi

# Function to create a symbolic link
create_link() {
  local src="$1"
  local dest="$2"
  local backup_dir="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
  
  # Check if source file exists
  if [[ ! -e "$src" ]]; then
    log_error "Source file does not exist: $src"
    return 1
  fi
  
  # Check if destination already exists
  if [[ -e "$dest" ]]; then
    if [[ -L "$dest" ]]; then
      local current_target="$(readlink "$dest")"
      if [[ "$current_target" == "$src" ]]; then
        log_info "Link already exists: $dest -> $src"
        return 0
      fi
      
      # If it's a symlink but points elsewhere, remove it instead of backing up
      if [[ "$DRY_RUN" == "false" ]]; then
        log_warning "Removing existing symlink: $dest -> $current_target"
        rm "$dest" || {
          log_error "Failed to remove existing symlink: $dest"
          return 1
        }
      else
        echo "  Would remove existing symlink: $dest -> $current_target"
      fi
    else
      # Backup existing file/directory
      log_warning "Backing up existing file: $dest"
      if [[ "$DRY_RUN" == "false" ]]; then
        mkdir -p "$backup_dir" || {
          log_error "Failed to create backup directory: $backup_dir"
          return 1
        }
        mv "$dest" "$backup_dir/" || {
          log_error "Failed to backup file: $dest to $backup_dir/"
          return 1
        }
        log_info "Backed up to: $backup_dir/$(basename "$dest")"
      else
        echo "  Would back up to: $backup_dir"
      fi
    fi
  fi
  
  # Create parent directory if it doesn't exist
  local parent_dir="$(dirname "$dest")"
  if [[ ! -d "$parent_dir" ]]; then
    log_info "Creating directory: $parent_dir"
    if [[ "$DRY_RUN" == "false" ]]; then
      mkdir -p "$parent_dir" || {
        log_error "Failed to create directory: $parent_dir"
        return 1
      }
    fi
  fi
  
  # Create symbolic link
  log_info "Creating link: $dest -> $src"
  if [[ "$DRY_RUN" == "false" ]]; then
    ln -sf "$src" "$dest" || {
      log_error "Failed to create symbolic link from $src to $dest"
      return 1
    }
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
  
  log_info "Symbolic links created successfully!"
}

# Run the main function
main
