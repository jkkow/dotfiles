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
pwsh .\installation\install.ps1 -Tools eza,starship,zoxide

# Keep elevated console open after run
pwsh .\installation\install.ps1 -All -PauseAtEnd
```

## Managed tools

- `eza`
- `starship`
- `wezterm`
- `yazi`
- `zed`
- `zoxide`

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

## Installation behavior

- Every package is installed via `winget` with `--scope machine`.
- Version policy is read from `installation/min-required-versions.txt`.
- If installed version is at or above minimum, the tool is skipped.
- If installed version is below minimum, the installer updates to the latest version.
- Config files are linked from this repository to `$HOME\.config`.
- A JSON summary is written to `installation/logs/`.
- A console table summary is printed by `installation/report-install-summary.ps1`.
