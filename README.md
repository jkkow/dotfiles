# dotfiles

Cross-platform configuration for Windows, Ubuntu, and Omarchy. Clone this repository directly into `~/.config`; tracked top-level directories are the managed application configurations.

## New Setup

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

## Existing Config Migration

Back up an existing configuration directory before cloning:

```sh
mv ~/.config ~/.config.backup
git clone <dotfiles-repository-url> ~/.config
```

On Windows PowerShell:

```powershell
Rename-Item -Path "$HOME\.config" -NewName ".config.backup"
git clone <dotfiles-repository-url> "$HOME\.config"
```

Use the repository version for managed directories. Restore every unmanaged directory from the backup after adding it to `.gitignore` when it should remain independent. Keep `~/.config.backup` until the new setup has been verified.

## Independent Configurations

Other applications can be managed in their own repositories. For example, Neovim is intentionally independent:

```sh
git clone <nvim-repository-url> ~/.config/nvim
```

`/nvim/` is listed in this repository's `.gitignore`, so normal Git operations in this repository do not track or modify it.

To add another independent configuration, add its top-level directory to `.gitignore` before restoring or cloning it:

```gitignore
/nvim/
/example-tool/
```

Then commit the ignore rule with the dotfiles repository. Confirm the result with `git status --ignored`. Do not run `git clean -fdx` from this repository because that command removes ignored directories.

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
