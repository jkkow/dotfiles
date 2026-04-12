#!/bin/bash
# =============================================================================
# Shared Helper Functions for Dotfiles Installation Scripts
# =============================================================================
# This file provides common logging and utility functions used by all tool
# installation scripts. Source this file in your tool-specific install.sh:
#   source "$(cd "$(dirname "${BASH_SOURCE[0]}")/lib" && pwd)/helpers.sh"
# =============================================================================

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# =============================================================================
# Logging Functions
# =============================================================================

log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

log_header() {
    local title="$1"
    local width=60
    echo
    echo -e "${BLUE}╔$(printf '═%.0s' {1..58})╗${NC}"
    printf "${BLUE}║${NC} %-56s ${BLUE}║${NC}\n" "$title"
    echo -e "${BLUE}╚$(printf '═%.0s' {1..58})╝${NC}"
    echo
}

log_separator() {
    echo -e "${CYAN}───────────────────────────────────────────────────────${NC}"
}

# =============================================================================
# Utility Functions
# =============================================================================

# Check if a command/tool is installed
detect_tool_installed() {
    local tool="$1"
    if command -v "$tool" &>/dev/null; then
        return 0
    else
        return 1
    fi
}

# Safely create a symlink, handling existing files
# Usage: create_symlink_safely "/path/to/source" "/path/to/link"
create_symlink_safely() {
    local source="$1"
    local link="$2"
    
    # Check if source exists
    if [[ ! -f "$source" ]]; then
        log_error "Source file not found: $source"
        return 1
    fi
    
    # Create parent directory if it doesn't exist
    local parent_dir=$(dirname "$link")
    if [[ ! -d "$parent_dir" ]]; then
        mkdir -p "$parent_dir"
        log_info "Created directory: $parent_dir"
    fi
    
    # Handle existing symlink or file
    if [[ -L "$link" ]]; then
        # It's a symlink
        local current_target=$(readlink "$link")
        if [[ "$current_target" == "$source" ]]; then
            log_success "Symlink already points to correct target"
            return 0
        else
            log_warning "Symlink points to different target: $current_target"
            log_info "Updating symlink..."
            rm "$link"
        fi
    elif [[ -f "$link" ]]; then
        # It's a regular file
        log_warning "Regular file exists at $link (not a symlink)"
        log_info "Backing up to $link.bak..."
        mv "$link" "$link.bak"
        log_success "Backed up to $link.bak"
    fi
    
    # Create the symlink
    log_info "Creating symlink: $link -> $source"
    ln -s "$source" "$link"
    
    # Verify the symlink
    if [[ -L "$link" ]] && [[ $(readlink "$link") == "$source" ]]; then
        log_success "Symlink created successfully"
        return 0
    else
        log_error "Failed to create symlink"
        return 1
    fi
}

# Verify that a symlink exists and points to the correct target
# Usage: verify_symlink "/path/to/link" "/path/to/expected/target"
verify_symlink() {
    local link="$1"
    local expected_target="$2"
    
    if [[ ! -L "$link" ]]; then
        log_error "Symlink does not exist: $link"
        return 1
    fi
    
    local actual_target=$(readlink "$link")
    if [[ "$actual_target" != "$expected_target" ]]; then
        log_error "Symlink points to wrong target"
        log_error "  Expected: $expected_target"
        log_error "  Got: $actual_target"
        return 1
    fi
    
    log_success "Symlink verified: $link -> $expected_target"
    return 0
}

# Check if a symlink target is readable
# Usage: verify_symlink_readable "/path/to/link"
verify_symlink_readable() {
    local link="$1"
    
    if [[ ! -f "$link" ]]; then
        log_error "Symlink target is not readable: $link"
        return 1
    fi
    
    log_success "Symlink target is readable"
    return 0
}

# =============================================================================
# Backup Functions
# =============================================================================

# Backup an existing file with timestamp
# Usage: backup_existing_file "/path/to/file"
backup_existing_file() {
    local file="$1"
    
    if [[ ! -f "$file" ]]; then
        return 0  # Nothing to backup
    fi
    
    local timestamp=$(date +%s)
    local backup="$file.backup.$timestamp"
    
    cp "$file" "$backup"
    log_success "Backed up to: $backup"
    return 0
}

# =============================================================================
# Export functions so they're available to sourced scripts
# =============================================================================

export -f log_info
export -f log_success
export -f log_warning
export -f log_error
export -f log_header
export -f log_separator
export -f detect_tool_installed
export -f create_symlink_safely
export -f verify_symlink
export -f verify_symlink_readable
export -f backup_existing_file
