# Starship

Starship is a fast, cross-shell prompt with configurable modules and themes.

## Install

```powershell
winget install --id Starship.Starship --exact --scope machine
scoop install main/starship
```

## Configure

This repo links the whole Starship config folder.

- source: `starship/`
- target: `$HOME\.config\starship`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\starship" -Target "C:\path\to\dotfiles\starship" -Force
```

Apply in current PowerShell session:

```powershell
. "$HOME\.config\powershell\setup_modules.ps1"
```
