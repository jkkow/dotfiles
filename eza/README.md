# Eza

Shell aliases are defined in the Bash and PowerShell configurations. Eza uses the `EZA_COLORS` environment variable for color customization; it does not automatically load `theme.yml` from this directory.

## Install

Windows:

```powershell
winget install --id eza-community.eza --exact --scope machine
```

Ubuntu or Omarchy: install `eza` with the distribution package manager.

## Configure

The YAML files in `themes/` are retained as color-theme references. To change eza colors on Windows, define `EZA_COLORS` in the PowerShell profile or use a `dircolors`-generated environment value. No XDG environment variable is required by eza.
