# AGENTS.md

## Source Of Truth
- Trust `install.sh` and `lib/helpers.sh` over the README when they conflict.
- Root entrypoint is `install.sh` in the repo root.

## Commands
- `bash install.sh --help` shows valid usage and tool names.
- `bash install.sh` with no args fails; pass explicit tools.
- Supported root tools: `eza`, `bash`, `starship`, `wezterm`, `yazi`, `zed`.
- Run one tool directly with `bash <tool>/install.sh`.
- From outside the repo, set `DOTFILES_DIR=/path/to/dotfiles` before running a tool script.

## Behavior To Remember
- `eza/install.sh` and `bash/install.sh` are the only fully working installers today.
- `starship/install.sh`, `wezterm/install.sh`, `yazi/install.sh`, and `zed/install.sh` are templates; they log TODOs and still return success.
- `install.sh` keeps going after a tool fails and prints a summary at the end.
- `lib/helpers.sh:create_symlink_safely` only accepts file sources (`[[ -f ... ]]`), so directory symlinks are not supported there.
- `create_symlink_safely` backs up existing regular files to `<path>.bak` and replaces incorrect symlinks.

## Repo Gotcha
- `bash/.bashrc` contains machine-specific cloud env vars (`GOOGLE_CLOUD_PROJECT`, `VERTEX_LOCATION`, `GOOGLE_CLOUD_REGION`); do not change them unless asked.

## Verification
- There is no CI/lint/test harness here.
- Verify changes by running the relevant install script(s) and checking the resulting symlink targets.
