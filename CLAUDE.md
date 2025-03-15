# CLAUDE.md for Dotfiles_Ubuntu Repository

## Repository Structure
This repository manages dotfiles for Ubuntu Server 24.04 with scripts to automate installation and configuration.

## Commands
- Setup repository: `git init && git add . && git commit -m "Initial commit"`
- Test installation script: `bash ./install.sh --dry-run`
- Test linking script: `bash ./link.sh --dry-run`
- Add execute permissions: `bash chmod.sh`
- Check shell scripts: `shellcheck ./install.sh ./link.sh ./packages/*.sh ./utils.sh ./chmod.sh`

## Utility Scripts
- `utils.sh`: Contains common utilities for all scripts
  - Environment validation: Checks for bash, Ubuntu
  - Color output: `print_header`, `log_info`, `log_warning`, `log_error`
  - System management: `update_system`, `command_exists`, `check_required_commands`, `is_root`
  - Support for dry run mode with `--dry-run` flag
  - Error handling with traps and cleanup

## Script Dependencies
- All scripts should source utils.sh and use its functions
- install.sh runs package scripts in packages/ directory, passing --dry-run when needed
- link.sh creates symbolic links from config/ directory to appropriate system locations
- chmod.sh adds execute permissions to all shell scripts

## Error Handling
- Check if required files/directories exist before using them
- Verify commands exist before executing them
- Handle errors from system commands
- Use proper exit codes and return values
- Provide confirmation prompts for potentially destructive operations
- Implement proper backup mechanisms

## Code Style Guidelines
- Shell scripts: Use POSIX-compatible syntax when possible
- Indentation: 2 spaces for all files
- Functions: Use snake_case for function names
- Variables: Use lowercase with underscores, prefix global variables to avoid collisions
- Comments: Begin with # and a space
- Error handling: Use exit codes and error messages with echo to stderr
- Always quote variables: Use "${variable}" not $variable

## Best Practices
- Make scripts idempotent (can run multiple times without side effects)
- Verify commands exist before using them
- Include clear documentation in README.md
- Add confirmation prompts for destructive operations
- Use dry run mode for testing dangerous operations
- Check for connectivity before downloading resources
- Validate environment before execution
- Support both x86_64 and ARM architectures when possible