# GlazeWM

GlazeWM and Zebar are Windows-only.

## Install

```powershell
winget install --id glzr-io.glazewm -e --scope user
```

Install Zebar separately if it is not included with the installed GlazeWM version.

## Configure

GlazeWM does not use `XDG_CONFIG_HOME` automatically. Set this user environment variable so it reads the configuration in this repository:

```powershell
[Environment]::SetEnvironmentVariable(
  "GLAZEWM_CONFIG_PATH",
  "$HOME\.config\glazewm\config.yaml",
  "User"
)
```

Restart GlazeWM after changing the variable or `config.yaml`.
