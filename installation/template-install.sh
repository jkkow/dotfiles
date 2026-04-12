#!/bin/bash
# =============================================================================
# TOOL_NAME Installation Script Template
# Copy this file to installation/<tool>-install.sh and replace placeholders.
#
# Recommended flow:
# 1) Optional: check/install the binary
# 2) Configure files via symlink
# 3) Verify expected end state
#
# Notes:
# - This template is idempotent: rerunning should be safe.
# - Keep real failures as non-zero returns so the orchestrator can report them.
# - create_symlink_safely supports file sources only (not directories).
# =============================================================================

set -e

# Resolve directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${DOTFILES_DIR:-$(cd "$SCRIPT_DIR/.." && pwd)}"
HELPERS_DIR="$DOTFILES_DIR/installation/lib"

# Source shared helpers
if [[ ! -f "$HELPERS_DIR/helpers.sh" ]]; then
	echo "Error: helpers.sh not found at $HELPERS_DIR/helpers.sh"
	exit 1
fi
source "$HELPERS_DIR/helpers.sh"

# =============================================================================
# Customize This Block
# =============================================================================

# Human/binary identifiers
TOOL_NAME="mytool"   # Used in logs and version policy checks
TOOL_BINARY="mytool" # Command name checked by detect_tool_installed

# File-based config link example (supported by create_symlink_safely)
CONFIG_DIR="$HOME/.config"
TOOL_CONFIG_SOURCE="$DOTFILES_DIR/mytool/config.toml"
TOOL_CONFIG_LINK="$CONFIG_DIR/mytool/config.toml"

# Directory-based config example (manual handling needed)
# TOOL_CONFIG_DIR_SOURCE="$DOTFILES_DIR/mytool"
# TOOL_CONFIG_DIR_LINK="$CONFIG_DIR/mytool"

# =============================================================================
# Binary Installation (Optional)
# Remove this section for config-only tools.
# =============================================================================

check_tool_installed() {
	if detect_tool_installed "$TOOL_BINARY"; then
		log_success "$TOOL_NAME is already installed"

		local tool_version_output
		tool_version_output="$("$TOOL_BINARY" --version 2>/dev/null || true)"
		if [[ -n "$tool_version_output" ]]; then
			echo "$tool_version_output"
		fi

		local tool_version
		tool_version="$(extract_semver "$tool_version_output" || true)"
		warn_if_below_min_version "$TOOL_NAME" "$tool_version"
		return 0
	fi

	return 1
}

install_tool() {
	log_info "$TOOL_NAME is not installed. Installing..."

	# TODO: Choose your installation strategy.
	# Example pattern:
	# if sudo apt update && sudo apt install -y "$TOOL_BINARY"; then
	#     log_success "$TOOL_NAME installed via apt"
	#     return 0
	# fi

	log_warning "TODO: implement installation logic for $TOOL_NAME"
	log_info "Returning success for now to keep template non-blocking"
	return 0
}

# =============================================================================
# Configuration Setup
# =============================================================================

setup_tool_config() {
	log_info "Setting up $TOOL_NAME configuration..."

	# File-link path (preferred when possible)
	if [[ ! -f "$TOOL_CONFIG_SOURCE" ]]; then
		log_warning "Config source file not found: $TOOL_CONFIG_SOURCE"
		log_info "Skipping $TOOL_NAME configuration setup"
		return 0
	fi

	if create_symlink_safely "$TOOL_CONFIG_SOURCE" "$TOOL_CONFIG_LINK"; then
		return 0
	fi

	return 1
}

verify_tool_setup() {
	log_info "Verifying $TOOL_NAME setup..."

	local success=true

	# Binary verification (optional for config-only tools)
	if detect_tool_installed "$TOOL_BINARY"; then
		log_success "$TOOL_NAME binary is installed"
	else
		log_warning "$TOOL_NAME binary is not installed"
		# For strict installers, set this to false.
		# success=false
	fi

	# File-link verification
	if [[ -f "$TOOL_CONFIG_SOURCE" ]]; then
		if ! verify_symlink "$TOOL_CONFIG_LINK" "$TOOL_CONFIG_SOURCE"; then
			success=false
		fi

		if ! verify_symlink_readable "$TOOL_CONFIG_LINK"; then
			success=false
		fi
	fi

	return $([ "$success" = true ] && echo 0 || echo 1)
}

# =============================================================================
# Main
# =============================================================================

main() {
	log_header "$TOOL_NAME Installation"

	# Optional binary install
	if ! check_tool_installed; then
		if ! install_tool; then
			log_error "Failed to install $TOOL_NAME"
			return 1
		fi
	fi

	log_separator

	# Configuration
	if ! setup_tool_config; then
		log_error "Failed to set up $TOOL_NAME configuration"
		return 1
	fi

	log_separator

	# Verification
	if verify_tool_setup; then
		log_success "$TOOL_NAME setup completed successfully!"
		return 0
	fi

	log_error "$TOOL_NAME verification failed"
	return 1
}

main "$@"
