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
  last_exit=$?

  red='\[\033[01;31m\]'
  green='\[\033[01;32m\]'
  yellow='\[\033[01;33m\]'
  blue='\[\033[01;34m\]'
  light_blue='\[\033[01;96m\]'
  reset='\[\033[00m\]' 

  # K8s bit
  if command -v kubectl &> /dev/null; then
    k8s="($(kubectl config current-context 2>/dev/null)|$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null))"
  fi

  # A chevron shows last exit code
  [[ $last_exit == 0 ]] && chev_a=$green || chev_a=$red

  # B chevron shows unstaged changes
  if [ -d .git ]; then
    git diff-index --quiet HEAD -- 2>/dev/null >/dev/null && chev_b=$green || chev_b=$yellow
  else
    chev_b=$reset
  fi

  # C chevron shows unpushed changes
  if [ -d .git ]; then
    [ -z "$(git log @{u}.. 2>/dev/null)"  ] && chev_c=$green || chev_c=$yellow
  else
    chev_c=$reset
  fi

  PS1="\n$green\u@\h $blue\w$light_blue\$(__git_ps1) $blue$k8s\n$chev_a›$chev_b›$chev_c›$reset "
}

PROMPT_COMMAND="__ps1"

# enable color support of common utilities
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

export EDITOR=nvim

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

[ -e /usr/lib/git-core/git-sh-prompt ] && source /usr/lib/git-core/git-sh-prompt
