# WezTerm

WezTerm is the terminal emulator used by this dotfiles setup.

## Install

```powershell
winget install --id wez.wezterm.nightly --exact --scope machine
scoop install extras/wezterm
```

- installer default uses `wez.wezterm.nightly` to satisfy minimum version policy
- minimum required version to be compatible with yazi on WSL: +20260331-040028-577474d8

## Configure

This repo links the whole WezTerm config folder so assets (for example `images/`) stay available.

- source: `wezterm/`
- target: `$HOME\.config\wezterm`

```powershell
New-Item -ItemType Directory -Path "$HOME\.config" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\.config\wezterm" -Target "C:\path\to\dotfiles\wezterm" -Force
```

Reload by restarting WezTerm.
