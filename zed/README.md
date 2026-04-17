# Zed

Zed is the code editor configuration tracked by this repository.

## Install

```powershell
winget install --id ZedIndustries.Zed --exact --scope machine
scoop install extras/zed
```

## Configure

This repo links the entire Zed config folder.

- source: `zed/`
- target: `$HOME\.config\zed`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\zed" -Target "C:\path\to\dotfiles\zed" -Force
```
