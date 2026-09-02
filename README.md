# dotfiles

Cross-platform configuration for Windows, Ubuntu, and Omarchy. Clone it to
`~/.config`.

## Install

Use one block only. The first is for a new machine; the second preserves an
existing configuration directory.

New setup:

```sh
git clone https://github.com/jkkow/dotfiles.git ~/.config
```

Existing setup on Windows PowerShell:

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
    $destination = Join-Path $configHome $name
    if (Test-Path -LiteralPath $source -PathType Container) {
        Move-Item -LiteralPath $source -Destination $destination
    }
}

git -C "$configHome" status --ignored
```

Keep `~/.config.backup` until the setup works. Restore only the ignored
directories listed below; copying the full backup would overwrite managed
configuration.

## Windows XDG Setup

Run the following block once in PowerShell after cloning. It creates the XDG directories and persists the user-level environment variables. Administrator privileges are not required.

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

Restart applications after running it. WezTerm uses `XDG_CONFIG_HOME`; other
Windows tools have their own setup steps below.

## Independent Configurations

The following top-level configuration folders are intentionally independent and ignored by this repository:

- `herdr`
- `lazygit`
- `nvim`
- `scoop`

They are not managed by this repository. Add a top-level directory to
`.gitignore` before restoring another independently managed configuration.
Do not run `git clean -fdx`: it removes ignored directories.

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
