# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.

# History configuration
HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=10000
HISTFILESIZE=20000

# Update window size after every command
shopt -s checkwinsize

# Enable color support for grep
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Source external aliases file if it exists
if [ -f ~/.bash_aliases ]; then
. ~/.bash_aliases
fi

# Set vi mode in bash (User preference)
set -o vi

# Custom PATH additions
export PATH="$HOME/.local/bin:$PATH"

# Prebuilt Neovim path and aliases
alias vi='nvim'

# Rust (Cargo) environment
if [ -f "$HOME/.cargo/env" ]; then
source "$HOME/.cargo/env"
fi

# Modern CLI tool replacements (eza)
alias ls='eza --icons --sort=Name'
alias ll='eza --icons --header --sort=Name -l'
alias la='eza --icons --header --sort=Name -la'
function lt {
eza --tree --icons --sort=type "$@"
}

# fzf configuration and key bindings
if [ -f ~/.fzf.bash ]; then
source ~/.fzf.bash
fi

export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2> /dev/null || find . -type f'
export FZF_CTRL_T_OPTS="--preview '[[ -d {} ]] && eza --tree --color=always {} | head -200 || bat --style=numbers --color=always --line-range :500 {}'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always --level=2 {} | head -200'"
export FZF_PREVIEW_COMMAND='bat --style=numbers --color=always --line-range :500 {}'
export FZF_DEFAULT_OPTS='--height 50% --layout=default --border --color=dark'

# zoxide initialization (smart cd replacement)
if command -v zoxide &> /dev/null; then
eval "$(zoxide init bash)"
fi

# Starship prompt initialization (Should be at the end of the file)
if command -v starship &> /dev/null; then
eval "$(starship init bash)"
fi
