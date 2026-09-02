# Windows Terminal

`settings.json` is the tracked source of truth. This guide supports the
Microsoft Store stable package and uses JetBrainsMono Nerd Font Mono with
D2CodingLigature Nerd Font available through Windows font fallback.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id Microsoft.WindowsTerminal --exact --scope machine
winget install --id Microsoft.PowerShell --exact --scope machine
```

Install JetBrainsMono Nerd Font Mono and D2CodingLigature Nerd Font before
opening Windows Terminal. Windows Terminal supports one configured font face;
Windows automatically selects fallback fonts for unsupported glyphs.

### Configure

Close Windows Terminal, then paste this block. It backs up an existing regular
settings file once and links the tracked file:

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
creation is denied.
