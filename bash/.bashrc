# Shared Bash configuration for Ubuntu and Omarchy.
[[ $- != *i* ]] && return

# Omarchy provides defaults outside this repository.
if [[ -f "$HOME/.local/share/omarchy/default/bash/rc" ]]; then
  source "$HOME/.local/share/omarchy/default/bash/rc"
fi

export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

if command -v nvim &>/dev/null; then
  export EDITOR="nvim"
  export VISUAL="nvim"
  alias vi='nvim'
  alias vim='nvim'
fi

HISTCONTROL=ignoreboth
HISTSIZE=10000
HISTFILESIZE=20000
shopt -s histappend checkwinsize
set -o vi
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

if command -v eza &>/dev/null; then
  function ls { eza --icons --sort=Name "$@"; }
  function ll { eza --icons --header --sort=Name -l "$@"; }
  function la { eza --icons --header --sort=Name -la "$@"; }
  function lt { eza --tree --icons --sort=type "$@"; }
fi

if command -v fzf &>/dev/null; then
  eval "$(fzf --bash)"
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2> /dev/null || find . -type f'
  export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=dark'
fi

if command -v zoxide &>/dev/null; then
  eval "$(zoxide init bash)"
fi

if ! shopt -oq posix; then
  if [[ -f /usr/share/bash-completion/bash_completion ]]; then
    source /usr/share/bash-completion/bash_completion
  elif [[ -f /etc/bash_completion ]]; then
    source /etc/bash_completion
  fi
fi

[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"
[[ -f "$HOME/.bash_aliases" ]] && source "$HOME/.bash_aliases"
[[ -f "$HOME/.bashrc.local" ]] && source "$HOME/.bashrc.local"

if command -v starship &>/dev/null; then
  eval "$(starship init bash)"
fi
