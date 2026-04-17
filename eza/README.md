# Eza

`eza` is a modern replacement for `ls` with icons and richer output.

## Install

```powershell
winget install --id eza-community.eza --exact --scope machine
scoop install main/eza
```

## Configure

This repo manages the theme file as a symbolic link.

- source: `eza/themes/tokyonight.yml`
- target: `$HOME\.config\eza\theme.yml`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\eza" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\eza\theme.yml" -Target "C:\path\to\dotfiles\eza\themes\tokyonight.yml" -Force
```
