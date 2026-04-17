# Dotfiles Installation (Windows Only)

This repository supports Windows-native installation only.

## Requirements

- Windows PowerShell 7 (`pwsh`)
- `winget` available
- Administrator elevation (script auto-relaunches with `RunAs`)

## Commands

Install all managed tools:

```powershell
pwsh .\installation\install.ps1 -All
```

Install selected tools:

```powershell
pwsh .\installation\install.ps1 -Tools powershell,eza,glazewm,starship,zoxide

# Keep elevated console open after run
pwsh .\installation\install.ps1 -All -PauseAtEnd
```

## Managed tools

- `eza`
- `glazewm`
- `powershell`
- `starship`
- `wezterm`
- `yazi`
- `zed`
- `zoxide`

### GlazeWM note

- The installer installs `glazewm` first.
- It does not install `zebar` separately; instead it verifies whether `zebar` is available after `glazewm` install and reports that status in the summary.
- The installer links the repository `glazewm` directory to `$HOME\.config\glazewm`.
- The installer migrates `~\.glzr\zebar` into `glazewm/zebar` and links `~\.glzr\zebar` back to that repo path.
- The installer sets `GLAZEWM_CONFIG_PATH` to `$HOME\.config\glazewm\config.yaml` (User scope).

### Yazi note

When you install `yazi` via `pwsh .\installation\install.ps1 -Tools yazi`, the installer also installs required dependencies:

- `ffmpeg`
- `7zip`
- `jq`
- `poppler`
- `fd`
- `ripgrep`
- `fzf`
- `zoxide`
- `imagemagick`

For detailed dependency rationale and alternative Scoop commands, see `yazi/README.md`.

### WezTerm note

- Installer default channel is `wez.wezterm.nightly` to satisfy the minimum required version policy.

## Installation behavior

- Packages are installed via `winget` with `--scope machine`; `powershell` falls back to default scope if machine scope is unsupported.
- If a package is already installed, the tool is skipped.
- Config files are linked from this repository to `$HOME\.config`.
- A JSON summary is written to `installation/logs/`.
- A console table summary is printed by `installation/report-install-summary.ps1`.
- When elevation is required, the installer replays the latest summary in the original shell after the elevated run exits.
