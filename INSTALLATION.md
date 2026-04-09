# Dotfiles Installation Guide

## Quick Commands

```bash
# Show valid tools and usage
bash install.sh --help

# Install selected tools (required; no default set)
bash install.sh eza bash

# Install all currently listed tools
bash install.sh eza bash starship wezterm yazi zed
```

`bash install.sh` with no args exits with an error.

Run a single tool directly:

```bash
bash eza/install.sh
# or from outside repo root
DOTFILES_DIR=/path/to/dotfiles bash /path/to/dotfiles/eza/install.sh
```

## What Is Implemented Today

- Fully implemented: `eza/install.sh`, `bash/install.sh`
- Stub/template scripts (currently log TODO and return success):
  - `starship/install.sh`
  - `wezterm/install.sh`
  - `yazi/install.sh`
  - `zed/install.sh`

Important: orchestrator success does not guarantee those stub tool configs were linked.

## Execution Model

- Root orchestrator: `install.sh`
- Shared helpers: `lib/helpers.sh`
- Per-tool logic: `<tool>/install.sh`
- Orchestrator continues after per-tool failures and prints a success/failure summary.

## Symlink Semantics (from `lib/helpers.sh`)

- `create_symlink_safely` only accepts file sources (`[[ -f ... ]]`).
- Existing regular target file is moved to `<target>.bak`.
- Existing incorrect symlink is removed and replaced.
- Helpers then verify link target and readability.

This means directory-to-directory linking is not supported by `create_symlink_safely` as currently written.

## Adding a New Tool (minimal pattern)

1. Create `mytool/install.sh` and source `lib/helpers.sh` using `DOTFILES_DIR` fallback.
2. Use helper functions for logs, symlink creation, and verification.
3. Return non-zero on real failures; keep script idempotent.
4. Add `mytool` to `AVAILABLE_TOOLS` in `install.sh`.
5. Test both paths:
   - `bash mytool/install.sh`
   - `bash install.sh mytool`

Fast reference for helper APIs: `detect_tool_installed`, `create_symlink_safely`, `verify_symlink`, `verify_symlink_readable`, `backup_existing_file`.
