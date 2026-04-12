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

# Resolve minimum versions file path
get_min_version_file_path() {
    local script_dir
    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
    local default_dotfiles_dir
    default_dotfiles_dir="$(cd "$script_dir/../.." && pwd)"
    local dotfiles_root="${DOTFILES_DIR:-$default_dotfiles_dir}"

    echo "$dotfiles_root/installation/min-required-versions.txt"
}

# Trim leading/trailing whitespace
trim_whitespace() {
    local value="$1"
    value="${value#"${value%%[![:space:]]*}"}"
    value="${value%"${value##*[![:space:]]}"}"
    echo "$value"
}

# Get minimum required version for a tool from the version file
# Usage: get_min_required_version "tool"
get_min_required_version() {
    local tool="$1"
    local version_file
    version_file="$(get_min_version_file_path)"

    if [[ ! -f "$version_file" ]]; then
        return 1
    fi

    local line
    while IFS= read -r line || [[ -n "$line" ]]; do
        line="${line%%#*}"
        line="$(trim_whitespace "$line")"

        if [[ -z "$line" ]] || [[ "$line" != *=* ]]; then
            continue
        fi

        local key="${line%%=*}"
        local value="${line#*=}"

        key="$(trim_whitespace "$key")"
        value="$(trim_whitespace "$value")"

        if [[ "$key" == "$tool" ]]; then
            echo "$value"
            return 0
        fi
    done < "$version_file"

    return 1
}

# Extract a semantic version (major.minor.patch) from version output
# Usage: extract_semver "tool version output"
extract_semver() {
    local raw="$1"

    if [[ "$raw" =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.${BASH_REMATCH[3]}"
        return 0
    fi

    if [[ "$raw" =~ ([0-9]+)\.([0-9]+) ]]; then
        echo "${BASH_REMATCH[1]}.${BASH_REMATCH[2]}.0"
        return 0
    fi

    return 1
}

# Compare semantic versions
# Usage: version_gte "installed" "required"
# Returns 0 if installed >= required, else 1
version_gte() {
    local installed="$1"
    local required="$2"

    local installed_parts required_parts
    IFS='.' read -r -a installed_parts <<< "$installed"
    IFS='.' read -r -a required_parts <<< "$required"

    local max_len="${#installed_parts[@]}"
    if [[ "${#required_parts[@]}" -gt "$max_len" ]]; then
        max_len="${#required_parts[@]}"
    fi

    local i installed_part required_part
    for ((i = 0; i < max_len; i++)); do
        installed_part="${installed_parts[i]:-0}"
        required_part="${required_parts[i]:-0}"

        if [[ ! "$installed_part" =~ ^[0-9]+$ ]] || [[ ! "$required_part" =~ ^[0-9]+$ ]]; then
            return 1
        fi

        if ((10#$installed_part > 10#$required_part)); then
            return 0
        fi

        if ((10#$installed_part < 10#$required_part)); then
            return 1
        fi
    done

    return 0
}

# Warn when installed tool version is below configured minimum
# Usage: warn_if_below_min_version "tool" "installed_version"
warn_if_below_min_version() {
    local tool="$1"
    local installed_version="$2"

    local required_version
    if ! required_version="$(get_min_required_version "$tool")"; then
        return 0
    fi

    if [[ -z "$installed_version" ]]; then
        log_warning "$tool installed version could not be parsed; minimum required is $required_version"
        return 0
    fi

    if version_gte "$installed_version" "$required_version"; then
        log_success "$tool version $installed_version meets minimum $required_version"
    else
        log_warning "$tool version $installed_version is below minimum $required_version (warning-only)"
    fi

    return 0
}

# Return required version for a tool or n/a if not configured
# Usage: get_required_version_or_na "tool"
get_required_version_or_na() {
    local tool="$1"
    local required

    if required="$(get_min_required_version "$tool")"; then
        echo "$required"
    else
        echo "n/a"
    fi
}

# Get installed semantic version for a command-like tool
# Usage: get_installed_version "tool"
# Returns: semver, not-installed, or unknown
get_installed_version() {
    local tool="$1"

    if ! detect_tool_installed "$tool"; then
        echo "not-installed"
        return 0
    fi

    local output
    output="$($tool --version 2>/dev/null || true)"
    if [[ -z "$output" ]]; then
        echo "unknown"
        return 0
    fi

    local parsed
    parsed="$(extract_semver "$output" || true)"
    if [[ -n "$parsed" ]]; then
        echo "$parsed"
    else
        echo "unknown"
    fi
}

# Evaluate installed version against required version policy
# Usage: evaluate_version_status "tool" "installed_version"
# Returns: meets, below-required, not-configured, not-installed, unknown
evaluate_version_status() {
    local tool="$1"
    local installed_version="$2"
    local required_version

    if [[ "$installed_version" == "not-installed" ]]; then
        echo "not-installed"
        return 0
    fi

    if ! required_version="$(get_min_required_version "$tool")"; then
        echo "not-configured"
        return 0
    fi

    if [[ "$installed_version" == "unknown" || -z "$installed_version" ]]; then
        echo "unknown"
        return 0
    fi

    if version_gte "$installed_version" "$required_version"; then
        echo "meets"
    else
        echo "below-required"
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
export -f get_min_version_file_path
export -f trim_whitespace
export -f get_min_required_version
export -f extract_semver
export -f version_gte
export -f warn_if_below_min_version
export -f get_required_version_or_na
export -f get_installed_version
export -f evaluate_version_status
export -f create_symlink_safely
export -f verify_symlink
export -f verify_symlink_readable
export -f backup_existing_file
