# Dotfiles Installation Guide

## Quick commands

```bash
# Usage and available tools
bash install.sh --help

# Install selected tools
bash install.sh eza bash

# Install all listed tools
bash install.sh --all
```

- `bash install.sh` with no args exits with an error.
- Root `install.sh` is a shim to `installation/install.sh`.

Run one tool directly:

```bash
bash installation/eza-install.sh
```

Run from outside the repo:

```bash
DOTFILES_DIR=/path/to/dotfiles bash /path/to/dotfiles/installation/eza-install.sh
```

## Installer model

- Orchestrator: `installation/install.sh`
- Shared helpers: `installation/lib/helpers.sh`
- Tool scripts: `installation/<tool>-install.sh`
- The orchestrator continues after per-tool failures.
- A summary table is printed at the end.

## Versions

- Version file: `installation/min-required-versions.txt`
- Format: `tool=major.minor.patch`
- Policy: warning only (no hard stop on lower versions)

## Symlink rules

- `create_symlink_safely` only supports file sources (`[[ -f ... ]]`).
- Existing regular files are moved to `<target>.bak`.
- Wrong symlinks are replaced.
- Link target and readability are verified after creation.

Directory-to-directory linking is not supported by `create_symlink_safely`.

## Add a new tool

1. Copy `installation/template-install.sh` to `installation/<tool>-install.sh`.
2. Update the "Customize This Block" values.
3. Source `installation/lib/helpers.sh` with `DOTFILES_DIR` fallback.
4. Return non-zero on real failures and keep the script idempotent.
5. Add the tool to `AVAILABLE_TOOLS` in `installation/install.sh`.
6. Test both paths:
   - `bash installation/<tool>-install.sh`
   - `bash installation/install.sh <tool>`

Helper API reference: `detect_tool_installed`, `create_symlink_safely`, `verify_symlink`, `verify_symlink_readable`, `backup_existing_file`.
