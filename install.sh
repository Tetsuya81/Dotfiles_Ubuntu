#!/bin/bash

# Ubuntu Server 24.04 Dotfiles Installation Script
# This script installs and configures all necessary packages and tools

set -e

# Support being sourced by other scripts
if [[ "${1}" == "--source-only" ]]; then
  return 0
fi

# Source common utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [[ ! -f "${SCRIPT_DIR}/utils.sh" ]]; then
  echo "Error: utils.sh not found in ${SCRIPT_DIR}"
  exit 1
fi
source "${SCRIPT_DIR}/utils.sh"

# Install essential packages
install_basic_packages() {
  print_header "Installing basic packages"
  
  local packages=("git" "curl" "wget" "build-essential" "pkg-config" \
                  "cmake" "ripgrep" "unzip" "ca-certificates" \
                  "gnupg" "software-properties-common" "zoxide")
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo apt install -y ${packages[@]}"
  else
    sudo apt install -y "${packages[@]}" || {
      log_error "Failed to install basic packages"
      exit 1
    }
  fi
}

# Run all package installation scripts
install_packages() {
  local package_scripts=("brew.sh" "miniforge.sh" "helix.sh" "github.sh" \
                        "tools.sh" "volta-claude.sh" "timedate.sh")
  
  for script in "${package_scripts[@]}"; do
    print_header "Running $script"
    local script_path="$DOTFILES_DIR/packages/$script"
    
    # Check if script exists
    if [[ ! -f "$script_path" ]]; then
      log_error "Script not found: $script_path"
      continue
    fi
    
    # Run script with appropriate flags
    if [[ "$DRY_RUN" == "true" ]]; then
      echo "Would run: $script_path --dry-run"
      if [[ -x "$script_path" ]]; then
        "$script_path" --dry-run || log_warning "Script $script would have failed"
      else
        bash "$script_path" --dry-run || log_warning "Script $script would have failed"
      fi
    else
      if [[ -x "$script_path" ]]; then
        "$script_path" || {
          log_error "Script $script failed to execute correctly"
          read -p "Continue with installation? (y/n): " -n 1 -r
          echo
          if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "Installation aborted by user"
            exit 1
          fi
        }
      else
        log_warning "Script $script is not executable. Running with bash."
        bash "$script_path" || {
          log_error "Script $script failed to execute correctly"
          read -p "Continue with installation? (y/n): " -n 1 -r
          echo
          if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "Installation aborted by user"
            exit 1
          fi
        }
      fi
    fi
  done
}

# Create symbolic links
create_symlinks() {
  print_header "Creating symbolic links"
  
  local link_script="$DOTFILES_DIR/link.sh"
  
  # Check if link script exists
  if [[ ! -f "$link_script" ]]; then
    log_error "Link script not found: $link_script"
    return 1
  fi
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: $link_script --dry-run"
    bash "$link_script" --dry-run
  else
    bash "$link_script" || {
      log_error "Failed to create symbolic links"
      return 1
    }
  fi
}

# Main installation process
main() {
  print_header "Starting installation of Dotfiles for Ubuntu Server 24.04"
  
  # Update system packages only once
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
