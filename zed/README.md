# Zed

## Install

Windows:

```powershell
winget install --id ZedIndustries.Zed --exact --scope machine
```

Ubuntu or Omarchy: install Zed with the distribution package manager or the official release method.

## Configure

On Linux, Zed reads this directory through its XDG configuration path. On Windows, Zed reads `%APPDATA%\Zed` and does not use `XDG_CONFIG_HOME` for `settings.json` or `keymap.json`.

Close Zed, back up any existing files under `%APPDATA%\Zed`, then create file-level symbolic links to this repository:

```powershell
$zedConfig = Join-Path $HOME ".config\zed"
$zedAppData = Join-Path $env:APPDATA "Zed"
New-Item -ItemType Directory -Path $zedAppData -Force | Out-Null

New-Item -ItemType SymbolicLink -Path (Join-Path $zedAppData "settings.json") -Target (Join-Path $zedConfig "settings.json")
New-Item -ItemType SymbolicLink -Path (Join-Path $zedAppData "keymap.json") -Target (Join-Path $zedConfig "keymap.json")
```

The commands intentionally fail if an existing file has not been backed up first. Enable Windows Developer Mode or run an elevated PowerShell session if symbolic-link creation is denied. Restart Zed after creating the links.
