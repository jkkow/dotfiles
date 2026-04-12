#!/bin/bash
# =============================================================================
# Zoxide Installation Script
# Installs zoxide binary for shell usage
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

# =============================================================================
# Zoxide Installation Functions
# =============================================================================

check_zoxide_installed() {
    if detect_tool_installed zoxide; then
        log_success "zoxide is already installed"
        local zoxide_version_output
        zoxide_version_output="$(zoxide --version)"
        echo "$zoxide_version_output"
        local zoxide_version
        zoxide_version="$(extract_semver "$zoxide_version_output" || true)"
        warn_if_below_min_version "zoxide" "$zoxide_version"
        return 0
    else
        return 1
    fi
}

install_zoxide() {
    log_info "zoxide is not installed. Installing..."

    log_info "Attempting to install zoxide via apt..."
    if sudo apt update && sudo apt install -y zoxide 2>/dev/null; then
        log_success "zoxide installed via apt"
        local zoxide_version_output
        zoxide_version_output="$(zoxide --version)"
        echo "$zoxide_version_output"
        local zoxide_version
        zoxide_version="$(extract_semver "$zoxide_version_output" || true)"
        warn_if_below_min_version "zoxide" "$zoxide_version"
        return 0
    fi

    log_warning "apt installation failed. Attempting cargo installation..."
    if detect_tool_installed cargo; then
        log_info "Installing zoxide via cargo..."
        if cargo install zoxide 2>/dev/null; then
            log_success "zoxide installed via cargo"
            log_warning "Ensure ~/.cargo/bin is in your PATH (add to ~/.bashrc if needed)"
            local zoxide_version_output
            zoxide_version_output="$(zoxide --version)"
            echo "$zoxide_version_output"
            local zoxide_version
            zoxide_version="$(extract_semver "$zoxide_version_output" || true)"
            warn_if_below_min_version "zoxide" "$zoxide_version"
            return 0
        fi
        log_error "Cargo installation failed"
        return 1
    fi

    log_error "Neither apt nor cargo available. Please install zoxide manually."
    log_info "Visit: https://github.com/ajeetdsouza/zoxide#installation"
    return 1
}

verify_zoxide_setup() {
    log_info "Verifying zoxide setup..."

    if detect_tool_installed zoxide; then
        log_success "zoxide is installed"
        return 0
    fi

    log_error "zoxide is not installed"
    return 1
}

# =============================================================================
# Main
# =============================================================================

main() {
    log_header "Zoxide Installation"

    if ! check_zoxide_installed; then
        if ! install_zoxide; then
            log_error "Failed to install zoxide"
            return 1
        fi
    fi

    log_separator

    if verify_zoxide_setup; then
        log_success "Zoxide installation completed successfully!"
        log_info "Reload your shell to apply changes: source ~/.bashrc"
        return 0
    fi

    log_error "Zoxide verification failed"
    return 1
}

main "$@"
