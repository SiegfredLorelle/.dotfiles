#
# ~/.zshrc
#

# Zsh interactive shell check (optional, .zshrc is for interactive by default)
# [[ -o INTERACTIVE ]] || return

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Zsh Prompt Customization
# %n: username
# %m: hostname
# %1d: basename of current directory (like Bash's \W)
# %#: hash for root, dollar for others
PS1='[%n@%m %1d]%# '

# Zsh Completion System
# Enable Zsh's own powerful completion
autoload -Uz compinit
compinit

# Pyenv
# Ensure PYENV_ROOT is set and pyenv is initialized if the directory exists
if [[ -d "$HOME/.pyenv" ]]; then
    export PYENV_ROOT="$HOME/.pyenv"
    # Add pyenv/bin to PATH if not already there
    if [[ ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
        export PATH="$PYENV_ROOT/bin:$PATH"
    fi
    # Initialize pyenv; this also handles adding ~/.pyenv/shims to PATH
    eval "$(pyenv init -)"
fi



# Additional common Zsh setup (Highly Recommended)
# This is a good place to put additional setup you'd typically find in a Zsh config.
# For example, if you want history to be persistent across sessions:
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory # Append new history lines to the history file

# Standard history navigation with cursor at the end of the line
bindkey '^[[A' history-search-backward # Up Arrow
bindkey '^[[B' history-search-forward  # Down Arrow

# --- Custom Keybindings for Word Traversal (Ctrl+Arrow) ---
bindkey '^[[1;5D' backward-word # Alt + Left Arrow
bindkey '^[[1;5C' forward-word  # Alt + Right Arrow
