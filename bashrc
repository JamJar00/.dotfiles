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

# PS1 setup
function __ps1() {
  GREEN='\[\033[01;32m\]'
  BLUE='\[\033[01;34m\]'
  LIGHT_BLUE='\[\033[01;96m\]'
  RESET='\[\033[00m\]' 

  echo "\n$GREEN\u@\h$RESET $BLUE\w$RESET$LIGHT_BLUE\$(__git_ps1)$RESET\n\$ "
}

PS1="$(__ps1)"

# enable color support of common utilities
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export EDITOR=vim

# Node version manager, if installed
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Rust stuff
[ -s "$HOME/.cargo/env" ] && \. "$HOME/.cargo/env"

# Make pip installed tools runnable easily
export PATH="$PATH:$HOME/.local/bin"

# Add mcfly
[ command -v mcfly &> /dev/null ] && eval "$(mcfly init bash)"

# Fix GPG signing with git not knowing how to ask for a password
export GPG_TTY=$(tty)
