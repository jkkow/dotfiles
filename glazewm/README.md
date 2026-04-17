# GlazeWM

GlazeWM is a tiling window manager for Windows. Zebar is used for the status bar.

## Install (recommended)

Use the repository installer:

```powershell
pwsh .\installation\install.ps1 -Tools glazewm
```

This does all of the following:

- Installs `glzr-io.glazewm` via winget.
- Verifies whether `zebar` is available after install and includes that status in the installation summary.
- Links the repo `glazewm` directory to `$HOME\.config\glazewm`.
- Migrates `~\.glzr\zebar` into `glazewm/zebar` and links `~\.glzr\zebar` to that repo path.
- Sets user environment variable `GLAZEWM_CONFIG_PATH=$HOME\.config\glazewm\config.yaml`.

## Manual install alternatives

```powershell
winget install --id glzr-io.glazewm --exact --scope machine

scoop install extras/glazewm
```

## Configuration

This repo tracks a single GlazeWM config file:

- source: `glazewm/config.yaml`
- target: `$HOME\.config\glazewm\config.yaml`
