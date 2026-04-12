# Dotfiles Installation Guide

## Quick Commands

```bash
# Show valid tools and usage
bash install.sh --help

# Install selected tools (required; no default set)
bash install.sh eza bash

# Install all currently listed tools
bash install.sh --all
```

`bash install.sh` with no args exits with an error.

Root `install.sh` is a compatibility shim that forwards to `installation/install.sh`.

Run a single tool directly:

```bash
bash installation/eza-install.sh
# or from outside repo root
DOTFILES_DIR=/path/to/dotfiles bash /path/to/dotfiles/installation/eza-install.sh
```

## What Is Implemented Today

- Fully implemented: `installation/eza-install.sh`, `installation/bash-install.sh`, `installation/zoxide-install.sh`
- Stub/template scripts (currently log TODO and return success):
  - `installation/starship-install.sh`
  - `installation/wezterm-install.sh`
  - `installation/yazi-install.sh`
  - `installation/zed-install.sh`

Important: orchestrator success does not guarantee those stub tool configs were linked.

## Execution Model

- Root orchestrator: `installation/install.sh`
- Shared helpers: `installation/lib/helpers.sh`
- Per-tool logic: `installation/<tool>-install.sh`
- Orchestrator continues after per-tool failures and prints a success/failure summary.

## Symlink Semantics (from `installation/lib/helpers.sh`)

- `create_symlink_safely` only accepts file sources (`[[ -f ... ]]`).
- Existing regular target file is moved to `<target>.bak`.
- Existing incorrect symlink is removed and replaced.
- Helpers then verify link target and readability.

This means directory-to-directory linking is not supported by `create_symlink_safely` as currently written.

## Adding a New Tool (minimal pattern)

1. Create `installation/mytool-install.sh` and source `installation/lib/helpers.sh` using `DOTFILES_DIR` fallback.
2. Use helper functions for logs, symlink creation, and verification.
3. Return non-zero on real failures; keep script idempotent.
4. Add `mytool` to `AVAILABLE_TOOLS` in `installation/install.sh`.
5. Test both paths:
   - `bash installation/mytool-install.sh`
   - `bash installation/install.sh mytool`

Fast reference for helper APIs: `detect_tool_installed`, `create_symlink_safely`, `verify_symlink`, `verify_symlink_readable`, `backup_existing_file`.
