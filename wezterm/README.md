# WezTerm

Terminal configuration for Windows, Ubuntu, and Omarchy. It uses JetBrainsMono
Nerd Font and D2KodingLigature Nerd Font when installed.

## Windows

### Install

Run in an elevated PowerShell session:

```powershell
winget install --id Microsoft.PowerShell --exact --scope machine
winget install --id wez.wezterm.nightly --exact --scope machine
```

Install the configured Nerd Fonts before using the terminal.

### Configure

Complete the Windows `Configure` section in the root `README.md`, then restart
WezTerm. The tracked `images/dark-desert.jpg` is used as the background.

## Ubuntu

### Install

```sh
sudo apt update
sudo apt install -y wezterm
```

### Configure

No additional configuration is required after cloning to `~/.config`.

## Omarchy

### Install

```sh
sudo pacman -S --needed wezterm
```

### Configure

No additional configuration is required after cloning to `~/.config`.
