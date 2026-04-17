# GlazeWM

GlazeWM is a tiling window manager for Windows. Zebar is used for the status bar.

## Install

```powershell
winget install --id glzr-io.glazewm --exact --scope machine
winget install --id glzr-io.zebar --exact --scope machine

scoop install extras/glazewm
scoop install extras/zebar
```

## Configure

This repo tracks a single config file.

- source: `glazewm/config.yaml`
- target: `$HOME\.config\glazewm\config.yaml`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config\glazewm" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\glazewm\config.yaml" -Target "C:\path\to\dotfiles\glazewm\config.yaml" -Force
setx GLAZEWM_CONFIG_PATH "$HOME\.config\glazewm\config.yaml"
```
