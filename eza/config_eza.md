# Eza Configuration (Windows)

## Install

`eza` is installed by `installation/install.ps1` using winget machine scope.

## Config path

This dotfiles repo links:

- source: `eza/themes/tokyonight.yml`
- target: `$HOME\.config\eza\theme.yml`

If you need to set it manually:

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\eza" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\eza\theme.yml" -Target "C:\path\to\dotfiles\eza\themes\tokyonight.yml" -Force
```
