# GlazeWM

GlazeWM and Zebar are Windows-only. The tracked configuration starts Zebar.

## Windows

### Install

```powershell
winget install --id glzr-io.glazewm -e --scope user
winget install --id glzr-io.zebar -e --scope user
```

### Configure

Set the configuration path once:

```powershell
$configPath = Join-Path $HOME ".config\glazewm\config.yaml"
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
    throw "GlazeWM config was not found: $configPath"
}
[Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $configPath, "User")
$env:GLAZEWM_CONFIG_PATH = $configPath
```

Start GlazeWM manually when needed:

```powershell
glazewm start
```

Press `Alt+Shift+R` to reload `config.yaml`. This guide does not configure
automatic startup.
