# =============================================================================
# ~/.bashrc
# Modern and readable configuration for Arch Linux (Omarchy)
# =============================================================================

# -----------------------------------------------------------------------------
# 0. ble.sh (Bash Line Editor) - MUST be at the very top
# -----------------------------------------------------------------------------
# Provides Zsh/Fish-like syntax highlighting and auto-suggestions
if [[ $- == *i* ]] && [[ -f ~/.local/share/blesh/ble.sh ]]; then
  source ~/.local/share/blesh/ble.sh
fi

# -----------------------------------------------------------------------------
# 1. Non-Interactive Check
# -----------------------------------------------------------------------------
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -----------------------------------------------------------------------------
# 2. Omarchy Defaults
# -----------------------------------------------------------------------------
# Load the default Omarchy aliases and functions
# (Overwrite them below if needed, do not edit the source directly)
if [[ -f ~/.local/share/omarchy/default/bash/rc ]]; then
  source ~/.local/share/omarchy/default/bash/rc
fi

# -----------------------------------------------------------------------------
# 3. Environment Variables
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$PATH"

# Google Cloud Vertex AI
export GOOGLE_CLOUD_PROJECT="grounded-nebula-491806-q4"
export VERTEX_LOCATION="global"
export GOOGLE_CLOUD_REGION="global"

# -----------------------------------------------------------------------------
# 4. History Configuration
# -----------------------------------------------------------------------------
# Ignore duplicate commands and lines starting with space
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend
# Increase history size
HISTSIZE=10000
HISTFILESIZE=20000

# -----------------------------------------------------------------------------
# 5. Shell Options & Keybindings
# -----------------------------------------------------------------------------
# Update window size after every command
shopt -s checkwinsize

# Set vi mode in bash
set -o vi

# Enable History Search via Up/Down Arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# -----------------------------------------------------------------------------
# 6. Aliases & Functions
# -----------------------------------------------------------------------------
# Prebuilt Neovim
alias vi='nvim'
alias vim='nvim'

# Enable color support for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Modern CLI tool replacements (eza)
# Using functions to properly accept and pass additional arguments ("$@")
ls() { eza --icons --sort=Name "$@"; }
ll() { eza --icons --header --sort=Name -l "$@"; }
la() { eza --icons --header --sort=Name -la "$@"; }
lt() { eza --tree --icons --sort=type "$@"; }

# -----------------------------------------------------------------------------
# 7. Modern CLI Tools Configuration (fzf, zoxide, starship)
# -----------------------------------------------------------------------------
# fzf: Command-line fuzzy finder
if command -v fzf &>/dev/null; then
  if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
  fi
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2> /dev/null || find . -type f'
  export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=dark'
  export FZF_CTRL_T_OPTS="--preview '[[ -d {} ]] && eza --tree --color=always {} | head -200 || bat --style=numbers --color=always --line-range :500 {}'"
  export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} | head -200'"
  export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range :500 {}'
fi

# zoxide: A smarter cd command
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# -----------------------------------------------------------------------------
# 8. External Sources
# -----------------------------------------------------------------------------
# Bash Completion (Tab completion enhancement)
if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

# Rust (Cargo) environment
if [[ -f "$HOME/.cargo/env" ]]; then
  source "$HOME/.cargo/env"
fi

# Source custom aliases if they exist
if [[ -f ~/.bash_aliases ]]; then
  source ~/.bash_aliases
fi

# -----------------------------------------------------------------------------
# 9. Prompt Initialization (Must be at the end)
# -----------------------------------------------------------------------------
# Starship: Cross-shell prompt
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi
