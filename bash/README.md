# Bash

This configuration is shared by Ubuntu and Omarchy. It loads Omarchy defaults only when they are present and loads optional private settings from `~/.bashrc.local`.

## Install

Install Bash, eza, fzf, zoxide, and Starship with the package manager for the current distribution. The configuration checks whether optional tools are installed before initializing them.

## Configure

Bash reads `~/.bashrc`, not an XDG configuration directory. Add this line to that file:

```bash
source "$HOME/.config/bash/.bashrc"
```

Reload the shell with `source ~/.bashrc`.
