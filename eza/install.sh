#!/bin/bash
# =============================================================================
# Eza Installation Script
# Sets up eza and configures theme via symbolic link
# Can be run independently or called by main install.sh
# =============================================================================

set -e

# Get the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
HELPERS_DIR="$DOTFILES_DIR/lib"

# Source helper functions
if [[ ! -f "$HELPERS_DIR/helpers.sh" ]]; then
    echo "Error: helpers.sh not found at $HELPERS_DIR/helpers.sh"
    exit 1
fi
source "$HELPERS_DIR/helpers.sh"

# Configuration
CONFIG_DIR="$HOME/.config"
EZA_CONFIG_DIR="$CONFIG_DIR/eza"
EZA_THEME_SOURCE="$DOTFILES_DIR/eza/themes/tokyonight.yml"
EZA_THEME_LINK="$EZA_CONFIG_DIR/theme.yml"

# =============================================================================
# Eza Installation Functions
# =============================================================================

check_eza_installed() {
    if detect_tool_installed eza; then
        log_success "eza is already installed"
        eza --version | head -1
        return 0
    else
        return 1
    fi
}

install_eza() {
    log_info "eza is not installed. Installing..."
    
    # Try apt first
    log_info "Attempting to install eza via apt..."
    if sudo apt update && sudo apt install -y eza 2>/dev/null; then
        log_success "eza installed via apt"
        eza --version | head -1
        return 0
    else
        log_warning "apt installation failed. Attempting cargo installation..."
        if detect_tool_installed cargo; then
            log_info "Installing eza via cargo..."
            if cargo install eza 2>/dev/null; then
                log_success "eza installed via cargo"
                log_warning "Ensure ~/.cargo/bin is in your PATH (add to ~/.bashrc if needed)"
                return 0
            else
                log_error "Cargo installation failed"
                return 1
            fi
        else
            log_error "Neither apt nor cargo available. Please install eza manually."
            log_info "Visit: https://github.com/eza-community/eza#installation"
            return 1
        fi
    fi
}

setup_eza_config() {
    log_info "Setting up eza configuration..."
    
    # Create config directory if it doesn't exist
    if [[ ! -d "$EZA_CONFIG_DIR" ]]; then
        log_info "Creating $EZA_CONFIG_DIR..."
        mkdir -p "$EZA_CONFIG_DIR"
        log_success "Created $EZA_CONFIG_DIR"
    else
        log_success "$EZA_CONFIG_DIR already exists"
    fi
    
    # Create symlink for theme
    if create_symlink_safely "$EZA_THEME_SOURCE" "$EZA_THEME_LINK"; then
        return 0
    else
        return 1
    fi
}

verify_eza_setup() {
    log_info "Verifying eza setup..."
    
    local success=true
    
    # Check eza is installed
    if ! detect_tool_installed eza; then
        log_error "eza is not installed"
        success=false
    else
        log_success "eza is installed"
    fi
    
    # Check symlink
    if ! verify_symlink "$EZA_THEME_LINK" "$EZA_THEME_SOURCE"; then
        success=false
    fi
    
    # Check symlink is readable
    if ! verify_symlink_readable "$EZA_THEME_LINK"; then
        success=false
    fi
    
    return $([ "$success" = true ] && echo 0 || echo 1)
}

# =============================================================================
# Main
# =============================================================================

main() {
    log_header "Eza Installation"
    
    # Check and install eza if needed
    if ! check_eza_installed; then
        if ! install_eza; then
            log_error "Failed to install eza"
            return 1
        fi
    fi
    
    log_separator
    
    # Setup eza configuration
    if ! setup_eza_config; then
        log_error "Failed to set up eza configuration"
        return 1
    fi
    
    log_separator
    
    # Verify setup
    if verify_eza_setup; then
        log_success "Eza installation completed successfully!"
        return 0
    else
        log_error "Eza verification failed"
        return 1
    fi
}

main "$@"
