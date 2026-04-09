# =============================================================================
# ~/.bashrc
# Bash configuration for Ubuntu
# =============================================================================

# -----------------------------------------------------------------------------
# 1. Non-Interactive Check
# -----------------------------------------------------------------------------
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# -----------------------------------------------------------------------------
# 2. Environment Variables
# -----------------------------------------------------------------------------
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

# Default editor (use nvim if available, else fall back to vim)
if command -v nvim &>/dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
elif command -v vim &>/dev/null; then
  export EDITOR="vim"
  export VISUAL="vim"
fi

# Google Cloud Vertex AI
export GOOGLE_CLOUD_PROJECT="grounded-nebula-491806-q4"
export VERTEX_LOCATION="global"
export GOOGLE_CLOUD_REGION="global"

# -----------------------------------------------------------------------------
# 3. History Configuration
# -----------------------------------------------------------------------------
# Ignore duplicate commands and lines starting with space
HISTCONTROL=ignoreboth
# Append to the history file, don't overwrite it
shopt -s histappend
# Increase history size
HISTSIZE=10000
HISTFILESIZE=20000

# -----------------------------------------------------------------------------
# 4. Shell Options & Keybindings
# -----------------------------------------------------------------------------
# Update window size after every command
shopt -s checkwinsize

# Set vi mode in bash
set -o vi

# Enable history search via Up/Down arrows
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# -----------------------------------------------------------------------------
# 5. Aliases & Functions
# -----------------------------------------------------------------------------
# Neovim aliases (only if installed)
if command -v nvim &>/dev/null; then
  alias vi='nvim'
  alias vim='nvim'
fi

# Color support for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Modern ls replacements (eza) - only if installed
# Using functions to properly accept and pass additional arguments ("$@")
if command -v eza &>/dev/null; then
  function ls { eza --icons --sort=Name "$@"; }
  function ll { eza --icons --header --sort=Name -l "$@"; }
  function la { eza --icons --header --sort=Name -la "$@"; }
  function lt { eza --tree --icons --sort=type "$@"; }
fi

# -----------------------------------------------------------------------------
# 6. Modern CLI Tools (fzf, zoxide)
# -----------------------------------------------------------------------------
# fzf: Command-line fuzzy finder
# need fzf version > 0.50
if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
fi

# zoxide: A smarter cd command
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

# -----------------------------------------------------------------------------
# 7. External Sources
# -----------------------------------------------------------------------------
# Bash completion
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

# Custom aliases
if [[ -f ~/.bash_aliases ]]; then
  source ~/.bash_aliases
fi

# -----------------------------------------------------------------------------
# 8. Prompt Initialization (Must be last)
# -----------------------------------------------------------------------------
# Starship: Cross-shell prompt
if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi
