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
  local last_exit=$?

  local red='\033[01;31m'
  local green='\033[01;32m'
  local yellow='\033[01;33m'
  local blue='\033[01;34m'
  local light_blue='\033[01;96m'
  local reset='\033[00m'

  # Git bit
  if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ] ; then
    local git_status=" $(git branch --show-current)"
  fi

  # K8s bit
  if command -v kubectl &> /dev/null; then
    local k8s=" $(kubectl config current-context 2>/dev/null) $(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)"
  fi

  # AWS bit
  local awss
  if [[ -n "$AWS_PROFILE" ]];then
    awss=" ${AWS_PROFILE}"
  fi

  local region="${AWS_REGION:-${AWS_DEFAULT_REGION:-$AWS_PROFILE_REGION}}"
  if [[ -n "$region" ]]; then
    awss="$awss ${region}"
  fi

  # A chevron shows last exit code
  local chev_a
  [[ $last_exit == 0 ]] && chev_a=$green || chev_a=$red

  # B chevron shows unstaged changes
  local chev_b
  if [ -d .git ]; then
    git diff-index --quiet HEAD -- 2>/dev/null >/dev/null && chev_b=$green || chev_b=$yellow
  else
    chev_b=$reset
  fi

  # C chevron shows unpushed changes
  local chev_c
  if [ -d .git ]; then
    [ -z "$(git log @{u}.. 2>/dev/null)"  ] && chev_c=$green || chev_c=$yellow
  else
    chev_c=$reset
  fi

  PS1="\n\[$green\]\w\[$light_blue\]$git_status\[$blue\]$k8s\[$red\]$awss\n\[$chev_a\]›\[$chev_b\]›\[$chev_c\]›\[$reset\] "
}

PROMPT_COMMAND="__ps1"

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
