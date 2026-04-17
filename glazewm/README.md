# GlazeWM Config (Windows)

This folder stores GlazeWM configuration managed by this repository.

## Install

```powershell
winget install --id glzr-io.glazewm --exact --scope machine
winget install --id glzr-io.zebar --exact --scope machine
```

## Config path

Set a persistent environment variable so GlazeWM loads this repo config:

```powershell
setx GLAZEWM_CONFIG_PATH "$HOME\.config\glazewm\config.yaml"
```

Then link this file to your config path if needed.
