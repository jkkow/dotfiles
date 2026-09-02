# Bash

Interactive-shell configuration with optional private settings in
`~/.bashrc.local`.

## Ubuntu

### Install

```sh
sudo apt update
sudo apt install -y eza fd-find fzf neovim starship zoxide
```

### Configure

```sh
mkdir -p "$HOME/.local/bin"
command -v fd >/dev/null 2>&1 || ln -s "$(command -v fdfind)" "$HOME/.local/bin/fd"
grep -qxF 'source "$HOME/.config/bash/.bashrc"' "$HOME/.bashrc" || \
  printf '\nsource "$HOME/.config/bash/.bashrc"\n' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

## Omarchy

### Install

```sh
sudo pacman -S --needed eza fd fzf neovim starship zoxide
```

### Configure

```sh
grep -qxF 'source "$HOME/.config/bash/.bashrc"' "$HOME/.bashrc" || \
  printf '\nsource "$HOME/.config/bash/.bashrc"\n' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```
