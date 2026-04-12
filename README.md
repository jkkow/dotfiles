# Dotfiles

Lightweight dotfiles installer for Linux/Ubuntu.

## Quick start

```bash
git clone git@github.com:jkkow/dotfiles.git ~/dotfiles
cd ~/dotfiles
bash install.sh --help
```

Install specific tools:

```bash
bash install.sh eza bash
```

Install all tools listed in the orchestrator:

```bash
bash install.sh --all
```

`install.sh` in the repo root is a shim to `installation/install.sh`.

## Structure

- Orchestrator: `installation/install.sh`
- Shared helpers: `installation/lib/helpers.sh`
- Tool installers: `installation/<tool>-install.sh`
- Tool template: `installation/template-install.sh`
- Minimum versions: `installation/min-required-versions.txt` (warning only)

## Behavior

- Running `bash install.sh` with no args fails and shows help.
- The orchestrator continues after per-tool failures and prints a summary.
- Existing regular files are backed up to `<path>.bak` before symlinking.

## Run a single tool

```bash
bash installation/eza-install.sh
```

From outside the repo:

```bash
DOTFILES_DIR=/path/to/dotfiles bash /path/to/dotfiles/installation/eza-install.sh
```

## Notes

- Reload shell after bash config changes: `source ~/.bashrc`
- `bash/.bashrc` contains machine-specific cloud env vars; edit with care.
- See `installation/INSTALLATION.md` for implementation details.
