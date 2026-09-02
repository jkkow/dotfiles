# dotfiles

Cross-platform configuration for Windows, Ubuntu, and Omarchy. Clone this repository directly into `~/.config`; tracked top-level directories are the managed application configurations.

## Existing Config Migration

Before cloning, check whether `~/.config` already exists. Use this migration section when it does; otherwise continue to **New Setup**.

Back up an existing configuration directory before cloning. Do not copy the entire backup back after cloning: doing so can overwrite managed directories. Restore only the independently managed folders listed below.

```sh
mv ~/.config ~/.config.backup
git clone <dotfiles-repository-url> ~/.config
```

On Windows PowerShell, copy and run the following block. It stops if a previous backup exists, clones this repository into a new configuration directory, then restores only independent configurations that exist in the backup:

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
git clone <dotfiles-repository-url> $configHome
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

git -C $configHome status --ignored
```

Keep `~/.config.backup` until the new setup has been verified. Restore any other unmanaged folders from that backup only after adding their top-level path to `.gitignore`.

## New Setup

Use this path only when `~/.config` does not exist or is empty.

```sh
git clone <dotfiles-repository-url> ~/.config
```

Install each application with the package manager for the current operating system. This repository does not install packages or modify files outside `~/.config`. Applications that use non-XDG startup files, including Bash, PowerShell, GlazeWM, and AutoHotkey, have a one-time manual setup step in their directory README.

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

Close and reopen affected applications after setting environment variables. XDG support is application-specific: WezTerm reads `XDG_CONFIG_HOME`, while Yazi, Zed, GlazeWM, AutoHotkey, and PowerShell require the application-specific steps in their README files.

Check the persisted values with:

```powershell
"XDG_CONFIG_HOME={0}" -f [Environment]::GetEnvironmentVariable("XDG_CONFIG_HOME", "User")
"XDG_DATA_HOME={0}" -f [Environment]::GetEnvironmentVariable("XDG_DATA_HOME", "User")
"XDG_CACHE_HOME={0}" -f [Environment]::GetEnvironmentVariable("XDG_CACHE_HOME", "User")
```

## Independent Configurations

The following top-level configuration folders are intentionally independent and ignored by this repository:

- `herdr`
- `lazygit`
- `nvim`
- `scoop`

They can be restored during migration or managed by their own repositories. For example, clone a separate Neovim configuration after this repository has been cloned:

```sh
git clone <nvim-repository-url> ~/.config/nvim
```

Normal Git operations in this repository do not track or modify these ignored folders.

To add another independent configuration, add its top-level directory to `.gitignore` before restoring or cloning it:

```gitignore
/herdr/
/lazygit/
/nvim/
/scoop/
/example-tool/
```

Then commit the ignore rule with the dotfiles repository before restoring or cloning that configuration. Confirm the result with `git status --ignored`. Do not run `git clean -fdx` from this repository because that command removes ignored directories.

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
