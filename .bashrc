# Source common functions
export BASH_ENV="$HOME/.bash_env"
[[ -f "$BASH_ENV" ]] && . "$BASH_ENV"
dotsource "$BASHLIBS/script-"
##############################################################################
#################### Standard Ubuntu/Debian bashrc stuff #####################
##############################################################################

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
################### dot-sourcing / sourcing files ######################
########################################################################

# enable programmable completion features
if ! shopt -oq posix; then
  dotsource /usr/share/bash-completion/bash_completion
  dotsource /etc/bash_completion
  dotsource-parts "$HOME/.bash_completions"
  dotsource-parts "$HOME/.local/share/bash-completion"
  which kubectl &> /dev/null && source <(kubectl completion bash)
  which argocd &> /dev/null && source <(argocd completion bash)
  which helm &> /dev/null && source <(helm completion bash)
fi

dotsource "$HOME/.bash_aliases"
dotsource "$HOME/.bashrc.local"

if [[ -d "$HOME/.pyenv" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  prepend-path "$PYENV_ROOT/bin"
  eval "$(pyenv init -)"
fi

[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"


#######################################################################
########################### Bash Macros ###############################
#######################################################################

# Launches EDITOR, Python executes EDITOR's output

bind -x '"\C-p": "run-in-env editor-to-cmd --file python3"'

##################################################################
###################### set prompt colors #########################
##################################################################

. "$HOME/dotfiles/termprompt.sh"
export PROMPT_COMMAND='set-ps1-prompt'
