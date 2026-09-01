# Windows Terminal

`settings.json` is the tracked source of truth. Windows Terminal reads it through a file symbolic link at its Microsoft Store `LocalState` path.

## Initial Setup

Run the following once from PowerShell. It preserves the prior settings file as `settings.json.backup` and atomically replaces the Terminal settings file with a link to this repository. The temporary link avoids a race where a running Terminal recreates `settings.json`.

```powershell
$terminalState = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$settings = Join-Path $terminalState "settings.json"
$source = Join-Path $HOME ".config\windows-terminal\settings.json"

if (Test-Path -LiteralPath $settings -PathType Leaf -and -not (Test-Path -LiteralPath "$settings.backup")) {
    Copy-Item -LiteralPath $settings -Destination "$settings.backup"
}

New-Item -ItemType SymbolicLink -Path "$settings.link" -Target $source
Move-Item -LiteralPath "$settings.link" -Destination $settings -Force
```

Enable Windows Developer Mode or run PowerShell as Administrator if creating the symbolic link is denied. Do not link the entire `LocalState` directory because it also contains application state and cache files.
