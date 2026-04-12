#!/bin/bash
# =============================================================================
# Yazi Installation Script
# Sets up yazi file manager configuration
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
YAZI_CONFIG_SOURCE="$DOTFILES_DIR/yazi"
YAZI_CONFIG_LINK="$CONFIG_DIR/yazi"
YAZI_RELEASE_BASE_URL="https://github.com/sxyazi/yazi/releases/download"
YAZI_SYSTEM_BIN_DIR="/usr/local/bin"
YAZI_RELEASE_ASSET="yazi-x86_64-unknown-linux-musl.zip"
YAZI_DEFAULT_VERSION="v26.1.22"

# =============================================================================
# Yazi Configuration Functions
# =============================================================================

run_privileged() {
  if [[ "$EUID" -eq 0 ]]; then
    "$@"
  elif [[ -t 0 && -t 1 ]]; then
    sudo "$@"
  else
    sudo -n "$@"
  fi
}

ensure_privilege_access() {
  if [[ "$EUID" -eq 0 ]]; then
    return 0
  fi

  if sudo -n true >/dev/null 2>&1; then
    return 0
  fi

  if [[ -t 0 && -t 1 ]]; then
    return 0
  fi

  log_error "System-wide Yazi installation requires sudo access"
  log_error "Run this script from an interactive terminal with sudo privileges"
  return 1
}

add_unique_package() {
  local package="$1"
  local existing

  for existing in "${MISSING_APT_PACKAGES[@]}"; do
    if [[ "$existing" == "$package" ]]; then
      return 0
    fi
  done

  MISSING_APT_PACKAGES+=("$package")
}

resolve_seven_zip_package() {
  if apt-cache show 7zip >/dev/null 2>&1; then
    echo "7zip"
    return 0
  fi

  if apt-cache show p7zip-full >/dev/null 2>&1; then
    echo "p7zip-full"
    return 0
  fi

  return 1
}

check_yazi_installed() {
  if detect_tool_installed yazi && detect_tool_installed ya; then
    local yazi_version_output yazi_version required_version required_semver
    required_version="$(resolve_required_yazi_version)"
    required_semver="${required_version#v}"

    yazi_version_output="$(yazi --version 2>/dev/null || true)"
    echo "$yazi_version_output"
    yazi_version="$(extract_semver "$yazi_version_output" || true)"

    if [[ -n "$yazi_version" ]] && version_gte "$yazi_version" "$required_semver"; then
      log_success "yazi is already installed and meets required version ($yazi_version >= $required_semver)"
      warn_if_below_min_version "yazi" "$yazi_version"
      return 0
    fi

    if [[ -z "$yazi_version" ]]; then
      log_warning "Installed yazi version could not be parsed; reinstalling required version $required_version"
    else
      log_info "Installed yazi version $yazi_version is below required $required_semver; upgrading"
    fi

    warn_if_below_min_version "yazi" "$yazi_version"
    return 1
  fi

  return 1
}

resolve_required_yazi_version() {
  local configured_version
  configured_version="$(get_min_required_version "yazi" || true)"

  if [[ -z "$configured_version" ]]; then
    echo "$YAZI_DEFAULT_VERSION"
    return 0
  fi

  if [[ "$configured_version" == v* ]]; then
    echo "$configured_version"
  else
    echo "v$configured_version"
  fi
}

install_yazi_dependencies() {
  log_info "Checking Yazi runtime dependencies..."

  local missing_required_commands=()
  local missing_optional_commands=()
  local MISSING_APT_PACKAGES=()
  local REQUIRED_APT_PACKAGES=()
  local OPTIONAL_APT_PACKAGES=()

  if ! detect_tool_installed curl; then missing_required_commands+=("curl"); fi
  if ! detect_tool_installed unzip; then missing_required_commands+=("unzip"); fi
  if ! detect_tool_installed file; then missing_required_commands+=("file"); fi

  if ! detect_tool_installed ffmpeg; then missing_optional_commands+=("ffmpeg"); fi
  if ! detect_tool_installed jq; then missing_optional_commands+=("jq"); fi
  if ! detect_tool_installed pdftoppm; then missing_optional_commands+=("poppler-utils"); fi
  if ! detect_tool_installed fd && ! detect_tool_installed fdfind; then missing_optional_commands+=("fd"); fi
  if ! detect_tool_installed rg; then missing_optional_commands+=("ripgrep"); fi
  if ! detect_tool_installed fzf; then missing_optional_commands+=("fzf"); fi
  if ! detect_tool_installed zoxide; then missing_optional_commands+=("zoxide"); fi
  if ! detect_tool_installed resvg; then missing_optional_commands+=("resvg"); fi
  if ! detect_tool_installed magick; then missing_optional_commands+=("imagemagick"); fi
  if ! detect_tool_installed 7z && ! detect_tool_installed 7zz; then missing_optional_commands+=("7z"); fi

  if [[ ${#missing_required_commands[@]} -eq 0 && ${#missing_optional_commands[@]} -eq 0 ]]; then
    log_success "Yazi runtime dependencies are already installed"
    return 0
  fi

  if ! ensure_privilege_access; then
    return 1
  fi

  local package resolved_package
  for package in "${missing_required_commands[@]}"; do
    case "$package" in
    curl)
      add_unique_package "curl"
      ;;
    unzip)
      add_unique_package "unzip"
      ;;
    file)
      add_unique_package "file"
      ;;
    esac
  done

  REQUIRED_APT_PACKAGES=("${MISSING_APT_PACKAGES[@]}")
  MISSING_APT_PACKAGES=()

  for package in "${missing_optional_commands[@]}"; do
    case "$package" in
    ffmpeg)
      resolved_package="ffmpeg"
      ;;
    jq)
      resolved_package="jq"
      ;;
    poppler-utils)
      resolved_package="poppler-utils"
      ;;
    fd)
      resolved_package="fd-find"
      ;;
    ripgrep)
      resolved_package="ripgrep"
      ;;
    fzf)
      resolved_package="fzf"
      ;;
    zoxide)
      resolved_package="zoxide"
      ;;
    resvg)
      resolved_package="resvg"
      ;;
    imagemagick)
      resolved_package="imagemagick"
      ;;
    7z)
      if resolved_package="$(resolve_seven_zip_package)"; then
        :
      else
        log_warning "Unable to find an apt package for 7-Zip; archive preview features will be limited"
        continue
      fi
      ;;
    esac

    if apt-cache show "$resolved_package" >/dev/null 2>&1; then
      add_unique_package "$resolved_package"
    else
      log_warning "Skipping optional dependency '$package' (apt package '$resolved_package' is unavailable)"
    fi
  done

  OPTIONAL_APT_PACKAGES=("${MISSING_APT_PACKAGES[@]}")

  if [[ ${#REQUIRED_APT_PACKAGES[@]} -gt 0 || ${#OPTIONAL_APT_PACKAGES[@]} -gt 0 ]]; then
    log_info "Updating apt package index"
    run_privileged apt-get update
  fi

  if [[ ${#REQUIRED_APT_PACKAGES[@]} -gt 0 ]]; then
    log_info "Installing required dependencies via apt: ${REQUIRED_APT_PACKAGES[*]}"
    if ! run_privileged env DEBIAN_FRONTEND=noninteractive apt-get install -y "${REQUIRED_APT_PACKAGES[@]}"; then
      log_error "Failed to install required Yazi dependencies"
      return 1
    fi
  fi

  if [[ ${#OPTIONAL_APT_PACKAGES[@]} -gt 0 ]]; then
    log_info "Installing optional dependencies via apt: ${OPTIONAL_APT_PACKAGES[*]}"
    if ! run_privileged env DEBIAN_FRONTEND=noninteractive apt-get install -y "${OPTIONAL_APT_PACKAGES[@]}"; then
      log_warning "Failed to install one or more optional Yazi dependencies; continuing"
    fi
  fi

  if ! detect_tool_installed fd && detect_tool_installed fdfind; then
    log_info "Creating fd compatibility symlink"
    if ! run_privileged ln -sf "$(command -v fdfind)" "$YAZI_SYSTEM_BIN_DIR/fd"; then
      log_error "Failed to create fd compatibility symlink"
      return 1
    fi
  fi

  if ! detect_tool_installed 7z && detect_tool_installed 7zz; then
    log_info "Creating 7z compatibility symlink"
    if ! run_privileged ln -sf "$(command -v 7zz)" "$YAZI_SYSTEM_BIN_DIR/7z"; then
      log_error "Failed to create 7z compatibility symlink"
      return 1
    fi
  fi

  local post_install_missing_required=()
  local post_install_missing_optional=()
  if ! detect_tool_installed curl; then post_install_missing_required+=("curl"); fi
  if ! detect_tool_installed unzip; then post_install_missing_required+=("unzip"); fi
  if ! detect_tool_installed file; then post_install_missing_required+=("file"); fi
  if ! detect_tool_installed ffmpeg; then post_install_missing_optional+=("ffmpeg"); fi
  if ! detect_tool_installed jq; then post_install_missing_optional+=("jq"); fi
  if ! detect_tool_installed pdftoppm; then post_install_missing_optional+=("poppler-utils"); fi
  if ! detect_tool_installed fd; then post_install_missing_optional+=("fd"); fi
  if ! detect_tool_installed rg; then post_install_missing_optional+=("ripgrep"); fi
  if ! detect_tool_installed fzf; then post_install_missing_optional+=("fzf"); fi
  if ! detect_tool_installed zoxide; then post_install_missing_optional+=("zoxide"); fi
  if ! detect_tool_installed resvg; then post_install_missing_optional+=("resvg"); fi
  if ! detect_tool_installed magick; then post_install_missing_optional+=("imagemagick"); fi
  if ! detect_tool_installed 7z; then post_install_missing_optional+=("7z"); fi

  if [[ ${#post_install_missing_required[@]} -gt 0 ]]; then
    log_error "Missing required Yazi runtime tools after installation: ${post_install_missing_required[*]}"
    return 1
  fi

  if [[ ${#post_install_missing_optional[@]} -gt 0 ]]; then
    log_warning "Missing optional Yazi runtime tools: ${post_install_missing_optional[*]}"
    if [[ " ${post_install_missing_optional[*]} " == *" resvg "* ]]; then
      log_warning "SVG preview will be unavailable until resvg is installed manually"
    fi
  fi

  log_success "Yazi runtime dependencies are ready"
  return 0
}

install_yazi_binary() {
  log_info "Installing yazi from GitHub pre-built binary..."

  if ! ensure_privilege_access; then
    return 1
  fi

  (
    set -e

    local release_version download_url temp_dir archive_path extract_dir yazi_bin ya_bin
    release_version="$(resolve_required_yazi_version)"
    download_url="$YAZI_RELEASE_BASE_URL/$release_version/$YAZI_RELEASE_ASSET"
    temp_dir="$(mktemp -d)"
    archive_path="$temp_dir/$YAZI_RELEASE_ASSET"
    extract_dir="$temp_dir/extract"

    mkdir -p "$extract_dir"

    log_info "Downloading $YAZI_RELEASE_ASSET for $release_version"
    curl -fsSL "$download_url" -o "$archive_path"

    log_info "Extracting Yazi archive"
    unzip -q "$archive_path" -d "$extract_dir"

    yazi_bin="$(find "$extract_dir" -type f -name yazi | head -n 1)"
    ya_bin="$(find "$extract_dir" -type f -name ya | head -n 1)"

    if [[ -z "$yazi_bin" || -z "$ya_bin" ]]; then
      log_error "Expected yazi and ya binaries were not found in the release archive"
      exit 1
    fi

    log_info "Installing binaries to $YAZI_SYSTEM_BIN_DIR"
    run_privileged install -m 755 "$yazi_bin" "$YAZI_SYSTEM_BIN_DIR/yazi"
    run_privileged install -m 755 "$ya_bin" "$YAZI_SYSTEM_BIN_DIR/ya"

    log_success "Yazi binaries installed"
  )
}

setup_yazi_config() {
  log_info "Setting up yazi configuration..."

  if [[ ! -d "$YAZI_CONFIG_SOURCE" ]]; then
    log_error "Yazi config directory not found: $YAZI_CONFIG_SOURCE"
    return 1
  fi

  local parent_dir current_target backup_target
  parent_dir="$(dirname "$YAZI_CONFIG_LINK")"

  if [[ ! -d "$parent_dir" ]]; then
    mkdir -p "$parent_dir"
    log_success "Created directory: $parent_dir"
  fi

  if [[ -L "$YAZI_CONFIG_LINK" ]]; then
    current_target="$(readlink "$YAZI_CONFIG_LINK")"
    if [[ "$current_target" == "$YAZI_CONFIG_SOURCE" ]]; then
      log_success "Yazi config symlink already points to the correct target"
      return 0
    fi

    log_warning "Yazi config symlink points to a different target: $current_target"
    rm "$YAZI_CONFIG_LINK"
  elif [[ -e "$YAZI_CONFIG_LINK" ]]; then
    backup_target="$YAZI_CONFIG_LINK.bak.$(date +%s)"
    log_warning "Existing path found at $YAZI_CONFIG_LINK"
    log_info "Backing up to $backup_target"
    mv "$YAZI_CONFIG_LINK" "$backup_target"
  fi

  log_info "Creating symlink: $YAZI_CONFIG_LINK -> $YAZI_CONFIG_SOURCE"
  ln -s "$YAZI_CONFIG_SOURCE" "$YAZI_CONFIG_LINK"

  if [[ -L "$YAZI_CONFIG_LINK" ]] && [[ "$(readlink "$YAZI_CONFIG_LINK")" == "$YAZI_CONFIG_SOURCE" ]]; then
    log_success "Yazi config symlink created successfully"
    return 0
  fi

  log_error "Failed to create yazi config symlink"
  return 1
}

verify_yazi_setup() {
  log_info "Verifying yazi setup..."

  local success=true

  if ! detect_tool_installed yazi; then
    log_error "yazi is not installed"
    success=false
  else
    log_success "yazi is installed"
    local yazi_version_output yazi_version
    yazi_version_output="$(yazi --version 2>/dev/null || true)"
    echo "$yazi_version_output"
    yazi_version="$(extract_semver "$yazi_version_output" || true)"
    warn_if_below_min_version "yazi" "$yazi_version"
  fi

  if ! detect_tool_installed ya; then
    log_error "ya is not installed"
    success=false
  else
    log_success "ya is installed"
  fi

  if ! verify_yazi_config_link; then
    success=false
  fi

  if ! verify_yazi_config_readable; then
    success=false
  fi

  if [[ "$success" == true ]]; then
    return 0
  fi

  return 1
}

verify_yazi_config_link() {
  if ! [[ -L "$YAZI_CONFIG_LINK" ]]; then
    log_error "Yazi config symlink does not exist: $YAZI_CONFIG_LINK"
    return 1
  fi

  local actual_target
  actual_target="$(readlink "$YAZI_CONFIG_LINK")"

  if [[ "$actual_target" != "$YAZI_CONFIG_SOURCE" ]]; then
    log_error "Yazi config symlink points to the wrong target"
    log_error "  Expected: $YAZI_CONFIG_SOURCE"
    log_error "  Got: $actual_target"
    return 1
  fi

  log_success "Yazi config symlink verified: $YAZI_CONFIG_LINK -> $YAZI_CONFIG_SOURCE"
  return 0
}

verify_yazi_config_readable() {
  if [[ -d "$YAZI_CONFIG_LINK" ]]; then
    log_success "Yazi config directory is readable"
    return 0
  fi

  log_error "Yazi config directory is not readable: $YAZI_CONFIG_LINK"
  return 1
}

# =============================================================================
# Main
# =============================================================================

main() {
  log_header "Yazi Configuration"

  if ! install_yazi_dependencies; then
    log_error "Failed to install Yazi runtime dependencies"
    return 1
  fi

  log_separator

  if ! check_yazi_installed; then
    if ! install_yazi_binary; then
      log_error "Failed to install yazi"
      return 1
    fi
  fi

  log_separator

  # Setup yazi configuration
  if ! setup_yazi_config; then
    log_error "Failed to set up yazi configuration"
    return 1
  fi

  log_separator

  # Verify setup
  if verify_yazi_setup; then
    log_success "Yazi installation completed successfully!"
    return 0
  else
    log_error "Yazi verification failed"
    return 1
  fi
}

main "$@"
