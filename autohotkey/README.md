# AutoHotkey

AutoHotkey provides keyboard remapping and Vim-style key motions on Windows.

## Install

```powershell
winget install --id AutoHotkey.AutoHotkey --exact --scope machine
scoop install extras/autohotkey
```

## Configure

This repo tracks a script file.

- source: `autohotkey/vim_alt_for_win.ahk`
- target: `$HOME\Documents\AutoHotkey\vim_alt_for_win.ahk`

```powershell
New-Item -ItemType Directory -Path "$HOME\Documents\AutoHotkey" -Force
New-Item -ItemType SymbolicLink -Path "$HOME\Documents\AutoHotkey\vim_alt_for_win.ahk" -Target "C:\path\to\dotfiles\autohotkey\vim_alt_for_win.ahk" -Force
```

Reload after changes:

```powershell
AutoHotkey.exe "$HOME\Documents\AutoHotkey\vim_alt_for_win.ahk" /restart
```
