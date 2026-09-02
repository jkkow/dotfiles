# Windows Terminal

`settings.json` is the tracked source of truth. This supports the Microsoft
Store stable package and requires JetBrainsMono Nerd Font Mono.

## Configure

Close Windows Terminal, then paste this into PowerShell. It backs up an
existing settings file once and replaces it with a link to this repository:

```powershell
$terminalState = Join-Path $env:LOCALAPPDATA "Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState"
$settings = Join-Path $terminalState "settings.json"
$source = Join-Path $HOME ".config\windows-terminal\settings.json"

if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
    throw "Tracked settings were not found: $source"
}
New-Item -ItemType Directory -Path $terminalState -Force | Out-Null
if (Test-Path -LiteralPath $settings) {
    $item = Get-Item -LiteralPath $settings -Force
    if (-not $item.LinkType -and -not (Test-Path -LiteralPath "$settings.backup")) {
        Copy-Item -LiteralPath $settings -Destination "$settings.backup"
    }
    Remove-Item -LiteralPath $settings -Force
}
New-Item -ItemType SymbolicLink -Path $settings -Target $source
```

Enable Windows Developer Mode or use an elevated PowerShell session if link
creation is denied. Do not link the full `LocalState` directory.
