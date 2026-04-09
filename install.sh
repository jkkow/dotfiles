#!/bin/bash
# =============================================================================
# Dotfiles Installation Orchestrator
# Coordinates tool-specific installation scripts
# =============================================================================

set -E  # Inherit ERR trap in functions

# Get the dotfiles directory
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPERS_DIR="$DOTFILES_DIR/lib"

# Source helper functions
if [[ ! -f "$HELPERS_DIR/helpers.sh" ]]; then
    echo "Error: helpers.sh not found at $HELPERS_DIR/helpers.sh"
    exit 1
fi
source "$HELPERS_DIR/helpers.sh"

# Available tools
declare -a AVAILABLE_TOOLS=("eza" "bash" "starship" "wezterm" "yazi" "zed")
declare -a TOOLS_TO_INSTALL=()
declare -a FAILED_TOOLS=()
declare -a SUCCESSFUL_TOOLS=()

# =============================================================================
# Helper Functions
# =============================================================================

show_help() {
    cat << EOF
Dotfiles Installation Orchestrator

Usage:
  bash install.sh [TOOL1] [TOOL2] ...
  bash install.sh --help

Available Tools:
$(printf '  - %s\n' "${AVAILABLE_TOOLS[@]}")

Examples:
  bash install.sh eza              # Install only eza
  bash install.sh eza bash         # Install eza and bash
  bash install.sh eza bash starship wezterm yazi zed
                                   # Install all tools
  bash install.sh --help           # Show this help message

Notes:
  - Each tool script is independently callable
  - Example: cd eza && bash install.sh
  - Failed tools won't stop the installation of other tools
  - Results summary is shown at the end

EOF
}

# Validate that a tool exists
is_valid_tool() {
    local tool="$1"
    for t in "${AVAILABLE_TOOLS[@]}"; do
        if [[ "$t" == "$tool" ]]; then
            return 0
        fi
    done
    return 1
}

# Parse command-line arguments
parse_arguments() {
    if [[ $# -eq 0 ]]; then
        log_error "No tools specified"
        echo
        show_help
        exit 1
    fi
    
    if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
        show_help
        exit 0
    fi
    
    for arg in "$@"; do
        if is_valid_tool "$arg"; then
            TOOLS_TO_INSTALL+=("$arg")
        else
            log_warning "Unknown tool: $arg (skipping)"
        fi
    done
    
    if [[ ${#TOOLS_TO_INSTALL[@]} -eq 0 ]]; then
        log_error "No valid tools specified"
        exit 1
    fi
}

# Execute a tool's installation script
execute_tool_install() {
    local tool="$1"
    local tool_script="$DOTFILES_DIR/$tool/install.sh"
    
    if [[ ! -f "$tool_script" ]]; then
        log_error "Installation script not found: $tool_script"
        return 1
    fi
    
    if [[ ! -x "$tool_script" ]]; then
        log_warning "Installation script is not executable: $tool_script"
        chmod +x "$tool_script"
    fi
    
    # Run the tool script with DOTFILES_DIR set
    DOTFILES_DIR="$DOTFILES_DIR" bash "$tool_script"
    return $?
}

# =============================================================================
# Main Installation Loop
# =============================================================================

main() {
    log_header "Dotfiles Installation Orchestrator"
    
    log_info "Dotfiles location: $DOTFILES_DIR"
    log_info "Tools to install: ${TOOLS_TO_INSTALL[*]}"
    
    log_separator
    
    # Install each tool
    for tool in "${TOOLS_TO_INSTALL[@]}"; do
        echo
        if execute_tool_install "$tool"; then
            SUCCESSFUL_TOOLS+=("$tool")
            log_success "$tool installation completed"
        else
            FAILED_TOOLS+=("$tool")
            log_warning "$tool installation failed (continuing with other tools...)"
        fi
        echo
    done
    
    # Print summary
    log_separator
    log_header "Installation Summary"
    
    if [[ ${#SUCCESSFUL_TOOLS[@]} -gt 0 ]]; then
        log_success "Successfully installed: ${SUCCESSFUL_TOOLS[*]}"
    fi
    
    if [[ ${#FAILED_TOOLS[@]} -gt 0 ]]; then
        log_error "Failed to install: ${FAILED_TOOLS[*]}"
        log_info "Review the errors above for details"
    fi
    
    # Final message
    echo
    if [[ ${#FAILED_TOOLS[@]} -eq 0 ]]; then
        log_success "All installations completed successfully!"
        log_info "Reload your shell to apply changes: source ~/.bashrc"
        return 0
    else
        log_warning "Some installations failed. See summary above."
        return 1
    fi
}

# =============================================================================
# Entry Point
# =============================================================================

# Parse arguments
parse_arguments "$@"

# Run main
main
