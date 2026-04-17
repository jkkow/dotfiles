# Yazi

Yazi is a terminal file manager used in this dotfiles setup.

## Install

```powershell
winget install --id sxyazi.yazi --exact --scope machine
scoop install main/yazi
```

## Configure

This repo links the entire Yazi config folder.

- source: `yazi/`
- target: `$HOME\.config\yazi`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\yazi" -Target "C:\path\to\dotfiles\yazi" -Force
```
