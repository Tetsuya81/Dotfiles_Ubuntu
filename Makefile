# Makefile for Ubuntu Dotfiles
# Automates installation and configuration tasks

.PHONY: all install link update packages check help dry-run

# Default target
all: help

# Install everything
install:
	@echo "Installing dotfiles and packages..."
	@bash ./install.sh

# Create symbolic links only
link:
	@echo "Creating symbolic links..."
	@bash ./link.sh

# Dry run mode (no changes made)
dry-run:
	@echo "Running in dry-run mode (no changes will be made)..."
	@bash ./install.sh --dry-run

# Update system packages only
update:
	@echo "Updating system packages..."
	@sudo apt update && sudo apt upgrade -y

# Install packages only
packages:
	@echo "Installing packages only..."
	@bash -c 'for script in ./packages/*.sh; do bash "$$script"; done'

# Check shell scripts with shellcheck
check:
	@echo "Checking shell scripts with shellcheck..."
	@shellcheck ./install.sh ./link.sh ./packages/*.sh || echo "Please install shellcheck: sudo apt install shellcheck"

# Help message
help:
	@echo "Ubuntu Dotfiles Makefile targets:"
	@echo "  make install    - Install dotfiles and packages"
	@echo "  make link       - Create symbolic links only"
	@echo "  make dry-run    - Dry run (no changes made)"
	@echo "  make update     - Update system packages only"
	@echo "  make packages   - Install packages only"
	@echo "  make check      - Check shell scripts for errors"
	@echo "  make help       - Show this help message"