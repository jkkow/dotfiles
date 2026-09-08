# GlazeWM

GlazeWM is Windows-only. Its configuration starts YASB when it is installed;
see [`yasb/README.md`](../yasb/README.md) for YASB setup.

## Windows

### Install

```powershell
winget install --id glzr-io.glazewm -e --scope user
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

Start GlazeWM manually when needed:

```powershell
glazewm start
```

Press `Alt+Shift+R` to reload GlazeWM's `config.yaml`. It does not rerun
`startup_commands`; start YASB separately or restart GlazeWM to apply its
lifecycle integration. This guide does not configure automatic startup.
