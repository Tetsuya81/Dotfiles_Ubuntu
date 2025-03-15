#!/bin/bash

# System time and date configuration script

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/install.sh" --source-only 2>/dev/null || {
  # Colors for output
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
  BLUE="\033[0;34m"
  NC="\033[0m" # No Color
  
  # Print header function
  print_header() {
    echo -e "\n${BLUE}===${NC} $1 ${BLUE}===${NC}\n"
  }
  
  # Dry run flag
  DRY_RUN=false
  if [[ "$1" == "--dry-run" ]]; then
    DRY_RUN=true
    echo -e "${YELLOW}Running in dry run mode. No changes will be made.${NC}"
  fi
}

print_header "Configuring system time and date"

# Set timezone to Asia/Tokyo (JST)
set_timezone() {
  local timezone="Asia/Tokyo"
  
  echo "Setting timezone to $timezone..."
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo timedatectl set-timezone $timezone"
  else
    sudo timedatectl set-timezone "$timezone"
    echo -e "${GREEN}Timezone set to $timezone successfully!${NC}"
  fi
}

# Enable NTP time synchronization
enable_ntp() {
  echo "Enabling NTP time synchronization..."
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo timedatectl set-ntp true"
  else
    sudo timedatectl set-ntp true
    echo -e "${GREEN}NTP time synchronization enabled!${NC}"
  fi
}

# Display current time settings
display_time_settings() {
  echo "Current time settings:"
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: timedatectl status"
  else
    timedatectl status
  fi
}

# Main function
main() {
  set_timezone
  enable_ntp
  display_time_settings
  
  echo -e "\n${GREEN}System time and date configuration completed!${NC}"
}

# Run the main function
main