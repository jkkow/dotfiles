# WezTerm

The configuration supports Windows, Ubuntu, and Omarchy. It selects PowerShell and Windows window options on Windows, and Bash on Linux.

## Install

Windows:

```powershell
winget install --id wez.wezterm.nightly --exact --scope machine
```

Ubuntu or Omarchy: install `wezterm` with the distribution package manager.

## Configure

WezTerm searches `XDG_CONFIG_HOME/wezterm/wezterm.lua` before its home-directory fallback. On Windows, run the root README's **Windows XDG Setup** once, then restart WezTerm after editing the configuration.
