# Eza configuration

## Installation

### On Windows

```
scoop install eza
```

### On Linux

Use Rust

```
cargo install eza

```

In this case, eza binary file will be located on `~/.cargo/bin/eza`

## Configuraion

### Set Configuration Directory

First, set your eza config directory. Default configuraion file location can be overriden by `$env:EZA_CONFIG_DIR`

on Windows

```
$env:EZA_CONFIG_DIR = "$env:USERPROFILE\.config\eza"
```

Linux default location is `~/.config/eza/`

### Set Symbolic Link

You may want to put `theme.yml` file in the configuration directory as a symbolic link.

on Windows

```shell
new-item -itemtype symboliclink -path "theme.yml" -target "C:\Users\jkkow\dev\dotfiles\eza\themes\tokyonight.yml"
```
on Linux

```bash
ln -s ~/.config/eza/theme.yml ~/dev/dotfiles/eza/theme/tokyonight.yml
```
