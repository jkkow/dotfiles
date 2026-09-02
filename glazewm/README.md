# GlazeWM

GlazeWM and Zebar are Windows-only.

## Install and Configure

Clone this repository to `$HOME\.config` before running the following block.
Paste it into PowerShell to install GlazeWM, configure it to use this
repository's `config.yaml`, and start it immediately:

```powershell
$ErrorActionPreference = "Stop"

winget install --id glzr-io.glazewm -e --scope user

$configPath = Join-Path $HOME ".config\glazewm\config.yaml"
if (-not (Test-Path -LiteralPath $configPath -PathType Leaf)) {
  throw "GlazeWM config was not found: $configPath"
}

[Environment]::SetEnvironmentVariable("GLAZEWM_CONFIG_PATH", $configPath, "User")
$env:GLAZEWM_CONFIG_PATH = $configPath

$glazeWm = Get-Command glazewm -ErrorAction Stop

& $glazeWm.Source start
```

`GLAZEWM_CONFIG_PATH` is saved as a user environment variable, so later
GlazeWM launches use `glazewm/config.yaml` from this repository. The script
does not configure GlazeWM to start automatically at sign-in.

To apply edits to `config.yaml` while GlazeWM is running, press
`Alt+Shift+R`.

The tracked configuration starts Zebar. Install it if `zebar` is unavailable:

```powershell
winget install --id glzr-io.zebar -e --scope user
```
