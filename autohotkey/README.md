# AutoHotkey

Windows-only AutoHotkey v2 shortcuts. `Ctrl+Shift+H/J/K/L` moves the cursor,
`Ctrl+Shift+Y/O` moves to line start/end, and `Ctrl+Alt+\` inserts the date.

## Windows

### Install

```powershell
winget install --id AutoHotkey.AutoHotkey -e --scope user
```

### Configure

Run the tracked script manually:

```powershell
$script = Join-Path $HOME ".config\autohotkey\vim_alt_for_win.ahk"
if (-not (Test-Path -LiteralPath $script -PathType Leaf)) {
    throw "AutoHotkey script was not found: $script"
}
Start-Process AutoHotkey.exe -ArgumentList ('"{0}"' -f $script)
```

Right-click the AutoHotkey tray icon to reload or exit it. The script does not
start automatically.
