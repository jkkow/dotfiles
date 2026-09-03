# GlazeWM

GlazeWM and Zebar are Windows-only. The tracked configuration starts Zebar.

## Windows

### Install

```powershell
winget install --id glzr-io.glazewm -e --scope user
winget install --id glzr-io.zebar -e --scope user
```

### Configure

Set the GlazeWM configuration path once:

```powershell
$configPath = Join-Path $HOME ".config\glazewm\config.yaml"
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw "GlazeWM config was not found: $configPath"
}
[Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $configPath, "User")
$env:GLAZEWM_CONFIG_PATH = $configPath
```

Install the tracked Zebar startup settings in Zebar's default configuration
directory:

```powershell
$sourcePath = Join-Path $HOME ".config\glazewm\zebar\settings.json"
$destinationPath = Join-Path $HOME ".glzr\zebar\settings.json"
if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "Zebar settings were not found: $sourcePath"
}
New-Item -ItemType Directory -Path (Split-Path -Parent $destinationPath) -Force | Out-Null
Copy-Item -LiteralPath $sourcePath -Destination $destinationPath -Force
```

Start GlazeWM manually when needed:

```powershell
glazewm start
```

Press `Alt+Shift+R` to reload `config.yaml`. This guide does not configure
automatic startup.
