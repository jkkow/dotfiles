# AutoHotkey

Windows-only AutoHotkey v2 shortcuts. `Ctrl+Shift+H/J/K/L` moves the cursor,
`Ctrl+Shift+Y/O` moves to line start/end, and `Ctrl+Alt+\` inserts the date.

## Windows

### Install

```powershell
winget install --id AutoHotkey.AutoHotkey -e --scope user
```

### Configure

Add the tracked executable to the current user's Startup folder:

```powershell
$executable = Join-Path $HOME ".config\autohotkey\vim_alt_for_win.exe"
if (-not (Test-Path -LiteralPath $executable -PathType Leaf)) {
    throw "AutoHotkey executable was not found: $executable"
}
$startup = [Environment]::GetFolderPath([Environment+SpecialFolder]::Startup)
$shortcut = Join-Path $startup "vim_alt_for_win.lnk"
$shell = New-Object -ComObject WScript.Shell
$link = $shell.CreateShortcut($shortcut)
$link.TargetPath = $executable
$link.WorkingDirectory = Split-Path -Parent $executable
$link.Save()
```

The hotkeys start automatically at the next sign-in. Right-click the AutoHotkey
tray icon to reload or exit them.

### Build

After changing `vim_alt_for_win.ahk`, rebuild the tracked executable:

```powershell
$script = Join-Path $HOME ".config\autohotkey\vim_alt_for_win.ahk"
$executable = Join-Path $HOME ".config\autohotkey\vim_alt_for_win.exe"
$compiler = Join-Path ${env:ProgramFiles} "AutoHotkey\Compiler\Ahk2Exe.exe"
if (-not (Test-Path -LiteralPath $compiler -PathType Leaf)) {
    throw "AutoHotkey compiler was not found: $compiler"
}
& $compiler /in $script /out $executable
```

The Startup-folder shortcut continues to use the rebuilt executable.
