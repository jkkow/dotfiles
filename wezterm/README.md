# WezTerm

WezTerm is the terminal emulator used by this dotfiles setup.

## Install

```powershell
winget install --id wez.wezterm --exact --scope machine
scoop install extras/wezterm
```

## Configure

This repo links the whole WezTerm config folder so assets (for example `images/`) stay available.

- source: `wezterm/`
- target: `$HOME\.config\wezterm`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "C:\path\to\dotfiles\wezterm" -Force
```

Reload by restarting WezTerm.
