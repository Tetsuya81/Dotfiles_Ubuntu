#!/bin/bash

# Common utilities for dotfiles installation scripts

# ----------------------------------------------
# Environment Validation
# ----------------------------------------------

# Check if we're running bash
if [ -z "$BASH_VERSION" ]; then
  echo "Error: This script requires bash. Please run with bash."
  exit 1
fi

# Check if we're on Ubuntu
if command -v lsb_release >/dev/null 2>&1; then
  DISTRO=$(lsb_release -is)
  if [[ "$DISTRO" != "Ubuntu" ]]; then
    echo "Warning: This script is designed for Ubuntu. Current distro: $DISTRO"
  fi
else
  echo "Warning: Unable to determine Linux distribution. This script is designed for Ubuntu."
fi

# ----------------------------------------------
# Colors for output (with fallback for terminals that don't support color)
# ----------------------------------------------
if [ -t 1 ]; then  # Check if stdout is a terminal
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;34m"
  NC="\033[0m" # No Color
else
  RED=""
  GREEN=""
  YELLOW=""
  BLUE=""
  NC=""
fi

# ----------------------------------------------
# Global variables - use prefix to avoid collision
# ----------------------------------------------
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_SYSTEM_UPDATED=false

# ----------------------------------------------
# Dry run flag - local scope to each script
# ----------------------------------------------
DRY_RUN=false
for arg in "$@"; do
  if [[ "$arg" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}Running in dry run mode. No changes will be made.${NC}"
    break
  fi
done

# Initialize trap to clean up on exit
trap cleanup EXIT

cleanup() {
  # Reset terminal colors
  echo -ne "${NC}"
}

# Print header function
print_header() {
  echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}\n"
}

# System update function
update_system() {
  local ret=0
  
  if [[ "$DOTFILES_SYSTEM_UPDATED" == "true" ]]; then
    log_info "System packages already updated."
    return 0
  fi
  
  print_header "Updating system packages"
  
  # Check for internet connectivity
  if ! ping -c 1 8.8.8.8 >/dev/null 2>&1 && ! ping -c 1 1.1.1.1 >/dev/null 2>&1; then
    log_error "No internet connectivity detected. Cannot update system."
    return 1
  fi
  
  # Check if apt command exists
  if ! command_exists apt; then
    log_error "apt command not found. Cannot update system packages."
    return 1
  fi
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo apt update"
    echo "Would run: sudo apt upgrade -y"
  else
    log_info "Updating package lists..."
    sudo apt update || {
      log_error "Failed to update package lists"
      ret=1
    }
    
    if [[ $ret -eq 0 ]]; then
      log_info "Upgrading packages..."
      sudo apt upgrade -y || {
        log_error "Failed to upgrade packages"
        ret=1
      }
    fi
  fi
  
  if [[ $ret -eq 0 ]]; then
    DOTFILES_SYSTEM_UPDATED=true
    log_info "System packages updated successfully."
  fi
  
  return $ret
}

# Function to check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check for required commands
check_required_commands() {
  local missing=false
  
  for cmd in "$@"; do
    if ! command_exists "$cmd"; then
      log_error "Required command not found: $cmd"
      missing=true
    fi
  done
  
  if [[ "$missing" == "true" ]]; then
    return 1
  fi
  
  return 0
}

# Function to check if running as root
is_root() {
  return $(id -u)
}

# Function to log information
log_info() {
  echo -e "${GREEN}INFO:${NC} $1" >&2
}

# Function to log warnings
log_warning() {
  echo -e "${YELLOW}WARNING:${NC} $1" >&2
}

# Function to log errors
log_error() {
  echo -e "${RED}ERROR:${NC} $1" >&2
}
