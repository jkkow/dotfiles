#!/bin/bash
# =============================================================================
# Bash Installation Script
# Creates symbolic link for .bashrc configuration
# Can be run independently or called by main install.sh
# =============================================================================

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
HELPERS_DIR="$DOTFILES_DIR/installation/lib"

# Source helper functions
if [[ ! -f "$HELPERS_DIR/helpers.sh" ]]; then
    echo "Error: helpers.sh not found at $HELPERS_DIR/helpers.sh"
    exit 1
fi
source "$HELPERS_DIR/helpers.sh"

# Configuration
BASH_CONFIG_SOURCE="$DOTFILES_DIR/bash/.bashrc"
BASH_CONFIG_LINK="$HOME/.bashrc"

# =============================================================================
# Bash Configuration Functions
# =============================================================================

setup_bash_config() {
    log_info "Setting up bash configuration..."
    
    # Create symlink for .bashrc
    if create_symlink_safely "$BASH_CONFIG_SOURCE" "$BASH_CONFIG_LINK"; then
        return 0
    else
        return 1
    fi
}

verify_bash_setup() {
    log_info "Verifying bash setup..."
    
    local success=true
    
    # Check symlink
    if ! verify_symlink "$BASH_CONFIG_LINK" "$BASH_CONFIG_SOURCE"; then
        success=false
    fi
    
    # Check symlink is readable
    if ! verify_symlink_readable "$BASH_CONFIG_LINK"; then
        success=false
    fi
    
    return $([ "$success" = true ] && echo 0 || echo 1)
}

# =============================================================================
# Main
# =============================================================================

main() {
    log_header "Bash Configuration"
    
    # Setup bash configuration
    if ! setup_bash_config; then
        log_error "Failed to set up bash configuration"
        return 1
    fi
    
    log_separator
    
    # Verify setup
    if verify_bash_setup; then
        log_success "Bash configuration setup completed successfully!"
        log_info "Reload your shell to apply changes: source ~/.bashrc"
        return 0
    else
        log_error "Bash configuration verification failed"
        return 1
    fi
}

main "$@"
