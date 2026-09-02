# dotfiles

Cross-platform configuration for Windows, Ubuntu, and Omarchy. Clone it to
`~/.config`.

## Windows

### Install

New machine:

```powershell
winget install --id Git.Git --exact --scope machine
git clone https://github.com/jkkow/dotfiles.git "$HOME\.config"
```

Existing configuration: this preserves only independently managed directories.

```powershell
$configHome = Join-Path $HOME ".config"
$backupHome = Join-Path $HOME ".config.backup"
$independentConfigs = "herdr", "lazygit", "nvim", "scoop"

if (Test-Path -LiteralPath $backupHome) {
    throw "Backup directory already exists: $backupHome"
}
if (-not (Test-Path -LiteralPath $configHome -PathType Container)) {
    throw "Configuration directory was not found: $configHome"
}

Rename-Item -LiteralPath $configHome -NewName ".config.backup"
git clone https://github.com/jkkow/dotfiles.git "$configHome"
if ($LASTEXITCODE -ne 0) {
    throw "Clone failed. Existing configuration remains in $backupHome"
}

foreach ($name in $independentConfigs) {
    $source = Join-Path $backupHome $name
    if (Test-Path -LiteralPath $source -PathType Container) {
        Move-Item -LiteralPath $source -Destination $configHome
    }
}
```

### Configure

Set the XDG environment variables once after cloning:

```powershell
$xdgConfig = Join-Path $HOME ".config"
$xdgData = Join-Path $HOME ".local\share"
$xdgCache = Join-Path $HOME ".cache"

foreach ($directory in $xdgConfig, $xdgData, $xdgCache) {
    New-Item -ItemType Directory -Path $directory -Force | Out-Null
}

[Environment]::SetEnvironmentVariable("XDG_CONFIG_HOME", $xdgConfig, "User")
[Environment]::SetEnvironmentVariable("XDG_DATA_HOME", $xdgData, "User")
[Environment]::SetEnvironmentVariable("XDG_CACHE_HOME", $xdgCache, "User")
```

Restart applications after setting environment variables.

## Ubuntu

### Install

New machine:

```sh
sudo apt update
sudo apt install -y git
git clone https://github.com/jkkow/dotfiles.git "$HOME/.config"
```

Existing configuration:

```sh
config_home="$HOME/.config"
backup_home="$HOME/.config.backup"

test ! -e "$backup_home" || { echo "Backup already exists: $backup_home" >&2; exit 1; }
mv "$config_home" "$backup_home"
git clone https://github.com/jkkow/dotfiles.git "$config_home"
for name in herdr lazygit nvim; do
  test -d "$backup_home/$name" && mv "$backup_home/$name" "$config_home/"
done
```

### Configure

No global setup is required. Applications use the standard `~/.config` path.

## Omarchy

### Install

New machine:

```sh
sudo pacman -S --needed git
git clone https://github.com/jkkow/dotfiles.git "$HOME/.config"
```

Existing configuration: use the Ubuntu existing-configuration block above.

### Configure

No global setup is required. Applications use the standard `~/.config` path.

## Independent Configurations

`herdr`, `lazygit`, and `nvim` are intentionally ignored on every platform.
`scoop` is also ignored on Windows. Do not run `git clean -fdx`: it removes
ignored directories.

## Tool Docs

- `bash/README.md`
- `powershell/README.md`
- `wezterm/README.md`
- `starship/README.md`
- `eza/README.md`
- `yazi/README.md`
- `zed/README.md`
- `glazewm/README.md`
- `autohotkey/README.md`
- `windows-terminal/README.md`
- `opencode/README.md`
