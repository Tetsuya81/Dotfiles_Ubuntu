# CLAUDE.md for Dotfiles_Ubuntu Repository

## Repository Structure
This repository manages dotfiles for Ubuntu Server 24.04 with scripts to automate installation and configuration.

## Commands
- Setup repository: `git init && git add . && git commit -m "Initial commit"`
- Test installation script: `bash ./install.sh --dry-run`
- Test linking script: `bash ./link.sh --dry-run`
- Check shell scripts: `shellcheck ./install.sh ./link.sh ./packages/*.sh`

## Code Style Guidelines
- Shell scripts: Use POSIX-compatible syntax when possible
- Indentation: 2 spaces for all files
- Functions: Use snake_case for function names
- Variables: Use lowercase with underscores
- Comments: Begin with # and a space
- Error handling: Use exit codes and error messages with echo to stderr
- Always quote variables: Use "${variable}" not $variable

## Best Practices
- Make scripts idempotent (can run multiple times without side effects)
- Verify commands exist before using them
- Include clear documentation in README.md
- Add confirmation prompts for destructive operations