# Zed

The configuration uses JetBrainsMonoNL Nerd Font and the `basepyright` and
`ruff` Python language servers.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id ZedIndustries.Zed --exact --scope machine
```

Install JetBrainsMonoNL Nerd Font, `basepyright`, and `ruff` before using Zed.

### Configure

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

## Ubuntu

### Install

```sh
curl -fsSL https://zed.dev/install.sh | sh
```

### Configure

No additional configuration is required after cloning to `~/.config`.

## Omarchy

### Install

```sh
sudo pacman -S --needed zed
```

### Configure

No additional configuration is required after cloning to `~/.config`.
