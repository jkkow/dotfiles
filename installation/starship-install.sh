#!/bin/bash
# =============================================================================
# Starship Installation Script
# Sets up starship prompt configuration
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
CONFIG_DIR="$HOME/.config"
STARSHIP_CONFIG_SOURCE="$DOTFILES_DIR/starship/starship.toml"
STARSHIP_CONFIG_LINK="$CONFIG_DIR/starship.toml"

# =============================================================================
# Starship Configuration Functions
# =============================================================================

check_starship_installed() {
    if detect_tool_installed starship; then
        log_success "starship is already installed"
        local starship_version_output
        starship_version_output="$(starship --version)"
        echo "$starship_version_output"
        local starship_version
        starship_version="$(extract_semver "$starship_version_output" || true)"
        warn_if_below_min_version "starship" "$starship_version"
        return 0
    else
        return 1
    fi
}

install_starship() {
    log_info "starship is not installed. Installing..."

    if curl -sS https://starship.rs/install.sh | sh; then
        log_success "starship installation command completed"
        if detect_tool_installed starship; then
            local starship_version_output
            starship_version_output="$(starship --version)"
            echo "$starship_version_output"
            local starship_version
            starship_version="$(extract_semver "$starship_version_output" || true)"
            warn_if_below_min_version "starship" "$starship_version"
        fi
        return 0
    else
        log_error "Failed to install starship"
        return 1
    fi
}

setup_starship_config() {
    log_info "Setting up starship configuration..."

    if [[ ! -f "$STARSHIP_CONFIG_SOURCE" ]]; then
        log_error "Starship config file not found: $STARSHIP_CONFIG_SOURCE"
        return 1
    fi

    if create_symlink_safely "$STARSHIP_CONFIG_SOURCE" "$STARSHIP_CONFIG_LINK"; then
        return 0
    else
        return 1
    fi
}

verify_starship_setup() {
    log_info "Verifying starship setup..."

    local success=true

    if ! detect_tool_installed starship; then
        log_error "starship is not installed"
        success=false
    else
        log_success "starship is installed"
    fi

    if ! verify_symlink "$STARSHIP_CONFIG_LINK" "$STARSHIP_CONFIG_SOURCE"; then
        success=false
    fi

    if ! verify_symlink_readable "$STARSHIP_CONFIG_LINK"; then
        success=false
    fi

    return $([ "$success" = true ] && echo 0 || echo 1)
}

# =============================================================================
# Main
# =============================================================================

main() {
    log_header "Starship Installation"

    if ! check_starship_installed; then
        if ! install_starship; then
            log_error "Failed to install starship"
            return 1
        fi
    fi

    log_separator

    # Setup starship configuration
    if ! setup_starship_config; then
        log_error "Failed to set up starship configuration"
        return 1
    fi

    log_separator

    # Verify setup
    if verify_starship_setup; then
        log_success "Starship installation completed successfully!"
        log_info "Reload your shell to apply changes: source ~/.bashrc"
        return 0
    else
        log_error "Starship verification failed"
        return 1
    fi
}

main "$@"
