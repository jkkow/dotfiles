#!/bin/bash
# =============================================================================
# Dotfiles Installation Orchestrator
# Coordinates tool-specific installation scripts
# =============================================================================

set -E  # Inherit ERR trap in functions

# Resolve directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
HELPERS_DIR="$DOTFILES_DIR/installation/lib"
INSTALLATION_DIR="$DOTFILES_DIR/installation"

# Source helper functions
if [[ ! -f "$HELPERS_DIR/helpers.sh" ]]; then
    echo "Error: helpers.sh not found at $HELPERS_DIR/helpers.sh"
    exit 1
fi
source "$HELPERS_DIR/helpers.sh"

# Available tools
declare -a AVAILABLE_TOOLS=("eza" "bash" "starship" "wezterm" "yazi" "zed" "zoxide")
declare -a TOOLS_TO_INSTALL=()
declare -a FAILED_TOOLS=()
declare -a SUCCESSFUL_TOOLS=()
declare -A TOOL_SCRIPT_EXIT=()
declare -A TOOL_STATUS=()
declare -A TOOL_REQUIRED_VERSION=()
declare -A TOOL_INSTALLED_VERSION=()
declare -A TOOL_VERSION_STATUS=()
declare -A TOOL_NOTE=()

# =============================================================================
# Helper Functions
# =============================================================================

show_help() {
    cat << EOF
Dotfiles Installation Orchestrator

Usage:
  bash install.sh [TOOL1] [TOOL2] ...
  bash install.sh --all
  bash install.sh --help

  # Direct invocation
  bash installation/install.sh [TOOL1] [TOOL2] ...
  bash installation/install.sh --all
  bash installation/install.sh --help

Available Tools:
$(printf '  - %s\n' "${AVAILABLE_TOOLS[@]}")

Examples:
  bash install.sh eza                           # Install only eza (shim)
  bash install.sh --all                         # Install every tool (shim)
  bash installation/install.sh eza              # Install only eza
  bash installation/install.sh eza bash         # Install eza and bash
  bash installation/install.sh --all            # Install every tool
  bash installation/install.sh --help           # Show this help message

Notes:
  - Each tool script lives under installation/<tool>-install.sh
  - Example: bash installation/eza-install.sh
  - Failed tools won't stop the installation of other tools
  - Results summary is shown at the end

EOF
}

# Add a tool to the installation queue without duplicates
enqueue_tool() {
    local tool="$1"
    for queued in "${TOOLS_TO_INSTALL[@]}"; do
        if [[ "$queued" == "$tool" ]]; then
            return 0
        fi
    done
    TOOLS_TO_INSTALL+=("$tool")
}

# Enqueue every available tool
enqueue_all_tools() {
    for tool in "${AVAILABLE_TOOLS[@]}"; do
        enqueue_tool "$tool"
    done
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

is_config_only_tool() {
    local tool="$1"
    case "$tool" in
        bash)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

expects_binary_tool() {
    local tool="$1"
    if is_config_only_tool "$tool"; then
        return 1
    fi

    return 0
}

collect_tool_result() {
    local tool="$1"
    local script_exit="$2"
    local required_version installed_version version_status status note

    TOOL_SCRIPT_EXIT["$tool"]="$script_exit"
    required_version="$(get_required_version_or_na "$tool")"
    installed_version="$(get_installed_version "$tool")"

    if is_config_only_tool "$tool"; then
        version_status="not-applicable"
    else
        version_status="$(evaluate_version_status "$tool" "$installed_version")"
    fi

    if [[ "$script_exit" -ne 0 ]]; then
        status="failed"
        note="installer exited with code $script_exit"
    elif expects_binary_tool "$tool" && [[ "$installed_version" == "not-installed" ]]; then
        status="incomplete"
        note="script succeeded but binary not found"
    elif is_config_only_tool "$tool"; then
        status="configured"
        note="configuration applied"
    else
        status="installed"
        case "$version_status" in
            meets)
                note="version meets minimum"
                ;;
            below-required)
                note="installed below minimum"
                ;;
            not-configured)
                note="no minimum version configured"
                ;;
            unknown)
                note="installed version could not be parsed"
                ;;
            *)
                note="installation completed"
                ;;
        esac
    fi

    TOOL_REQUIRED_VERSION["$tool"]="$required_version"
    TOOL_INSTALLED_VERSION["$tool"]="$installed_version"
    TOOL_VERSION_STATUS["$tool"]="$version_status"
    TOOL_STATUS["$tool"]="$status"
    TOOL_NOTE["$tool"]="$note"
}

print_detailed_summary() {
    local installed_count=0 configured_count=0 incomplete_count=0 failed_count=0
    local tool status

    log_header "Installation Summary"
    printf "%-10s | %-10s | %-10s | %-13s | %-15s | %s\n" "tool" "status" "required" "installed" "version" "notes"
    printf "%-10s-+-%-10s-+-%-10s-+-%-13s-+-%-15s-+-%s\n" "----------" "----------" "----------" "-------------" "---------------" "------------------------------"

    for tool in "${TOOLS_TO_INSTALL[@]}"; do
        status="${TOOL_STATUS[$tool]}"
        printf "%-10s | %-10s | %-10s | %-13s | %-15s | %s\n" \
            "$tool" \
            "$status" \
            "${TOOL_REQUIRED_VERSION[$tool]}" \
            "${TOOL_INSTALLED_VERSION[$tool]}" \
            "${TOOL_VERSION_STATUS[$tool]}" \
            "${TOOL_NOTE[$tool]}"

        case "$status" in
            installed)
                ((installed_count++))
                ;;
            configured)
                ((configured_count++))
                ;;
            incomplete)
                ((incomplete_count++))
                ;;
            failed)
                ((failed_count++))
                ;;
        esac
    done

    log_separator
    log_info "Totals -> installed: $installed_count, configured: $configured_count, incomplete: $incomplete_count, failed: $failed_count"
}

# Parse command-line arguments
parse_arguments() {
    if [[ $# -eq 0 ]]; then
        log_error "No tools specified"
        echo
        show_help
        exit 1
    fi
    
    for arg in "$@"; do
        case "$arg" in
            --help|-h)
                show_help
                exit 0
                ;;
            --all|-a)
                enqueue_all_tools
                ;;
            *)
                if is_valid_tool "$arg"; then
                    enqueue_tool "$arg"
                else
                    log_warning "Unknown tool: $arg (skipping)"
                fi
                ;;
        esac
    done
    
    if [[ ${#TOOLS_TO_INSTALL[@]} -eq 0 ]]; then
        log_error "No valid tools specified"
        exit 1
    fi
}

# Execute a tool's installation script
execute_tool_install() {
    local tool="$1"
    local tool_script="$INSTALLATION_DIR/${tool}-install.sh"
    
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
            collect_tool_result "$tool" 0
            SUCCESSFUL_TOOLS+=("$tool")
            log_success "$tool installation completed"
        else
            local exit_code=$?
            collect_tool_result "$tool" "$exit_code"
            FAILED_TOOLS+=("$tool")
            log_warning "$tool installation failed (continuing with other tools...)"
        fi
        echo
    done

    # Print summary
    log_separator
    print_detailed_summary

    if [[ ${#FAILED_TOOLS[@]} -gt 0 ]]; then
        log_error "Failed tools: ${FAILED_TOOLS[*]}"
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
