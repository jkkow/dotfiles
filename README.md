# Dotfiles

Bash-based dotfiles installer for Linux/Ubuntu, with tool-specific install scripts and shared symlink helpers.

## Quick Start

```bash
git clone git@github.com:jkkow/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh --help
```

Install selected tools (required; no default set):

```bash
# Core working tools
bash install.sh eza bash

# All currently listed tools
bash install.sh --all
```

`install.sh` at repo root is a compatibility shim that forwards to `installation/install.sh`.

Reload shell after bash config changes:

```bash
source ~/.bashrc
```

## Current Tool Status

- Implemented and verified: `installation/eza-install.sh`, `installation/bash-install.sh`
- Template/stub scripts (return success but do not fully link configs yet):
  - `installation/starship-install.sh`
  - `installation/wezterm-install.sh`
  - `installation/yazi-install.sh`
  - `installation/zed-install.sh`

## How The Installer Works

- Root orchestrator: `installation/install.sh`
- Shared functions: `installation/lib/helpers.sh`
- Per-tool scripts: `installation/<tool>-install.sh`
- Orchestrator continues after per-tool failures and prints a summary at the end.

Run one tool directly:

```bash
bash installation/eza-install.sh
# or, from outside repo root
DOTFILES_DIR=/path/to/dotfiles bash /path/to/dotfiles/installation/eza-install.sh
```

## Symlink Behavior

- Helpers create symlinks and verify target/readability.
- If target path is a regular file, it is moved to `<path>.bak` before linking.
- If target path is an incorrect symlink, it is replaced.

Quick verification example:

```bash
ls -l ~/.config/eza/theme.yml
```

## Notes

- `bash/.bashrc` contains machine-specific cloud env vars.
- `installation/INSTALLATION.md` has the fuller architecture/template guide for adding tools.
