# Zed

Windows, in an elevated PowerShell session:

```powershell
winget install --id ZedIndustries.Zed --exact --scope machine
```

On Ubuntu or Omarchy, install Zed with the distribution package manager or its
official release method. On Windows, Zed needs links because it does not use
`XDG_CONFIG_HOME` for these files. The configuration requires JetBrainsMonoNL
Nerd Font and uses the `basepyright` and `ruff` Python language servers.

## Configure Windows

Close Zed, then paste this block. It backs up existing regular files once and
links the tracked settings and keymap:

```powershell
$zedConfig = Join-Path $HOME ".config\zed"
$zedAppData = Join-Path $env:APPDATA "Zed"
New-Item -ItemType Directory -Path $zedAppData -Force | Out-Null

foreach ($name in "settings.json", "keymap.json") {
    $source = Join-Path $zedConfig $name
    $destination = Join-Path $zedAppData $name
    if (-not (Test-Path -LiteralPath $source -PathType Leaf)) {
        throw "Tracked Zed file was not found: $source"
    }
    if (Test-Path -LiteralPath $destination) {
        $item = Get-Item -LiteralPath $destination -Force
        if (-not $item.LinkType -and -not (Test-Path -LiteralPath "$destination.backup")) {
            Copy-Item -LiteralPath $destination -Destination "$destination.backup"
        }
        Remove-Item -LiteralPath $destination -Force
    }
    New-Item -ItemType SymbolicLink -Path $destination -Target $source | Out-Null
}
```

Enable Windows Developer Mode or use an elevated PowerShell session if link
creation is denied, then restart Zed.
