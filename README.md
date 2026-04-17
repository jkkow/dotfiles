# dotfiles

Windows-first dotfiles for PowerShell, WezTerm, Starship, Yazi, Zed, and related tools.

## Quick Start

Run the installer (auto-elevates to Administrator):

```powershell
pwsh .\installation\install.ps1 -All
```

Install selected tools only:

```powershell
pwsh .\installation\install.ps1 -Tools eza,starship,wezterm,yazi,zed,zoxide
```

For full installer behavior, requirements, and policy details, see `installation/README.md`.

Yazi needs additional preview/search dependencies (`ffmpeg`, `7zip`, `jq`, `poppler`, `fd`, `ripgrep`, `fzf`, `zoxide`, `imagemagick`).
Use `pwsh .\installation\install.ps1 -Tools yazi` to install Yazi and its required dependencies, or see `yazi/README.md` for winget and Scoop commands.

## Tool Docs

- `powershell/README.md`
- `wezterm/README.md`
- `starship/README.md`
- `eza/README.md`
- `yazi/README.md`
- `zed/README.md`
- `glazewm/README.md`
- `autohotkey/README.md`
