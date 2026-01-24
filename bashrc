# A lot of this stuff is default ubuntu bashrc, see the bottom for custom settings

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# append to the history file, don't overwrite it
shopt -s histappend

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of common utilities
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# And set the colours to not awful
export LS_COLORS=$LS_COLORS:'tw=00;33:ow=01;33:'

export EDITOR=nvim

function dotfiles-update() {
  dotbot_dir=$(dirname -- $(readlink -f -- ~/.bashrc))
  git -C "${dotbot_dir}" pull --rebase
  source ~/.bashrc
}

# Node version manager, if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust stuff
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# Make pip installed tools runnable easily
export PATH="$PATH:$HOME/.local/bin"

export PATH="$PATH:$HOME/.bin"

# Add mcfly
command -v mcfly &> /dev/null && eval "$(mcfly init bash)"

# Fix GPG signing with git not knowing how to ask for a password
export GPG_TTY=$(tty)

# Add completion for Homebrew packages
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Add Kubectl completion
command -v kubectl &> /dev/null && source <(kubectl completion bash)

# Include local bashrc file
[ -s "$HOME/.bashrc.local" ] && \. "$HOME/.bashrc.local"

# Set prompt
export PS1='$(prompt --exit-code $? --message "bash")'

alias tea="poetry -P ~/Projects/tea run tea"
