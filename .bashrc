#############################################################################
###################### Standard Ubuntu bashrc stuff #########################
#############################################################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac
export TERM="xterm-256color"
# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Disable XOFF being triggered by Ctrl+S
stty -ixon

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=2000
HISTFILESIZE=5000

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
  debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

########################################################################
################### Functions required in .bashrc ######################
########################################################################

function is-shell-script {
  file -i "$1" | grep -q "text/x-shellscript"
}

function dotsource-parts {
  local SOURCE_DIR="$1"
  if [[ -d "$SOURCE_DIR" ]]; then
    for file in "$SOURCE_DIR"/*; do
      if [[ -f "$file" ]] && is-shell-script "$file"; then
        . "$file"
      fi
    done
  fi
}

function append-path {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
  export PATH
}

########################################################################
###################### declare / set variables #########################
########################################################################

append-path "$HOME/bin"
append-path "$HOME/.local/bin"
append-path "$HOME/.local/share/ansi"

########################################################################
################### dot-sourcing / sourcing files ######################
########################################################################


# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    dotsource-parts "$HOME/.bash_completions"
    dotsource-parts "$HOME/.local/share/bash-completion"
  fi
fi

if [ -f "$HOME/.bash_aliases" ]; then
  . "$HOME/.bash_aliases"
fi

if [ -f "$HOME/.bashrc.local" ]; then
  . "$HOME/.bashrc.local"
fi


# Import all files in ~/.local/bash-libs if the dir exists
BASHLIBS_DIR="$HOME/.local/lib/bash-libs"
if [ -d "$BASHLIBS_DIR" ]; then
  shopt -s nullglob
  dotsource-parts "$BASHLIBS_DIR"
fi

##################################################################
###################### set prompt colors #########################
##################################################################

. ~/dotfiles/termprompt.sh
PROMPT_COMMAND='set-ps1-prompt'

