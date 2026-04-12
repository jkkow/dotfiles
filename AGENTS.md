# AGENTS.md

## Source Of Truth
- Trust `installation/install.sh` and `installation/lib/helpers.sh` over the README when they conflict.
- Root entrypoint is `installation/install.sh`.

## Commands
- `bash install.sh --help` works via root compatibility shim.
- `bash installation/install.sh --help` shows valid usage and tool names.
- `bash installation/install.sh` with no args fails; pass explicit tools.
- `bash installation/install.sh --all` installs every available tool in one run.
- Supported root tools: `eza`, `bash`, `starship`, `wezterm`, `yazi`, `zed`, `zoxide`.
- Run one tool directly with `bash installation/<tool>-install.sh`.
- From outside the repo, set `DOTFILES_DIR=/path/to/dotfiles` before running a tool script.

## Behavior To Remember
- `installation/eza-install.sh`, `installation/bash-install.sh`, `installation/zoxide-install.sh`, and `installation/yazi-install.sh` contain real installation logic.
- `installation/starship-install.sh`, `installation/wezterm-install.sh`, and `installation/zed-install.sh` are templates that currently return success.
- `installation/install.sh` keeps going after a tool fails and prints a summary at the end.
- `installation/lib/helpers.sh:create_symlink_safely` only accepts file sources (`[[ -f ... ]]`), so directory symlinks are not supported there.
- `create_symlink_safely` backs up existing regular files to `<path>.bak` and replaces incorrect symlinks.

## Repo Gotcha
- `bash/.bashrc` contains machine-specific cloud env vars (`GOOGLE_CLOUD_PROJECT`, `VERTEX_LOCATION`, `GOOGLE_CLOUD_REGION`); do not change them unless asked.

## Verification
- There is no CI/lint/test harness here.
- Verify changes by running the relevant install script(s) and checking the resulting symlink targets.
