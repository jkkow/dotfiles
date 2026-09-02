# Bash

Shared Ubuntu and Omarchy interactive-shell configuration. Optional private
settings load from `~/.bashrc.local`.

## Configure

Install `eza`, `fzf`, `zoxide`, `starship`, `fd`, and `neovim` with your
distribution's package manager, then paste this once:

```bash
$config = "$HOME/.config/bash/.bashrc"
grep -qxF 'source "$HOME/.config/bash/.bashrc"' "$HOME/.bashrc" || \
  printf '\nsource "$HOME/.config/bash/.bashrc"\n' >> "$HOME/.bashrc"
source "$HOME/.bashrc"
```

The configuration applies to interactive Bash sessions only.
