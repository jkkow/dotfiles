# AutoHotkey

`vim_alt_for_win.ahk` provides Vim-style keyboard motions on Windows.

## Install

```powershell
winget install --id AutoHotkey.AutoHotkey -e --scope user
```

## Configure

AutoHotkey does not discover XDG configuration directories. Run the script directly:

```powershell
AutoHotkey.exe "$HOME\.config\autohotkey\vim_alt_for_win.ahk"
```

To start it automatically, create a shortcut to that command in the Windows Startup folder.
