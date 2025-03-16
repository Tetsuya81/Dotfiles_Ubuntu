#!/bin/bash

# System time and date configuration script

set -e

# Source common utilities
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../" && pwd)"
source "$DOTFILES_DIR/utils.sh"

print_header "Configuring system time and date"

# Set timezone to Asia/Tokyo (JST)
set_timezone() {
  local timezone="Asia/Tokyo"
  
  echo "Setting timezone to $timezone..."
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo timedatectl set-timezone $timezone"
  else
    sudo timedatectl set-timezone "$timezone"
    log_info "Timezone set to $timezone successfully!"
  fi
}

# Enable NTP time synchronization
enable_ntp() {
  echo "Enabling NTP time synchronization..."
  
  if [[ "$DRY_RUN" == "true" ]]; then
    echo "Would run: sudo timedatectl set-ntp true"
  else
    sudo timedatectl set-ntp true
    log_info "NTP time synchronization enabled!"
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
  
  log_info "System time and date configuration completed!"
}

# Run the main function
main
