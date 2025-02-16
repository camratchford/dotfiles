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

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

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
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'


# enable programmable completion features
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
    # not in original, but should be
    run-parts $HOME/.bash_completions/
  fi
fi


########################################################################
###################### declare / set variables #########################
########################################################################

export PATH="$HOME/zig:/sbin:/usr/sbin:/usr/local/bin:/snap/bin:$PATH"
export EDITOR=/usr/bin/vim


if [ -d "$HOME/.pulumi/bin" ]; then
    export PATH="$HOME/.pulumi/bin:$PATH"
fi

#export PAGER="/usr/share/vim/vim82/macros/less.sh"

##############################################################################
###################### dot-sourcing / sourcing files #########################
##############################################################################

if [ -f "$HOME/.bash_aliases" ]; then
    . "$HOME/.bash_aliases"
fi

function isASCII {
    file --mime-encoding "$1" | grep -q 'us-ascii'
}

# Import all files in ~/.local/bash-libs if the dir exists
BASHLIBS_DIR="$HOME/.local/bash-libs"
if [ -d "$BASHLIBS_DIR" ]; then
    shopt -s nullglob
    for LIBFILE in "$BASHLIBS_DIR"/*; do
        if [[ -f "$LIBFILE" && isASCII "$LIBFILE" ]]; then
            . "$LIBFILE"
        fi
    done
fi

# Set env vars for ansible
gh_token=$(cat ~/.git-credentials | grep -P "ghp_[A-Za-z0-9]*" -o)
if [ -n "$gh_token" ]; then
  export GITHUB_TOKEN="${gh_token}"
fi

gh_username=$(cat ~/.git-credentials | grep -P "(?<=\/\/{1})[a-z\-]*(?=:{1})" -o)
if [ -n "$gh_username" ]; then
  export GITHUB_USERNAME="${gh_username}"
fi


##################################################################
###################### set prompt colors #########################
##################################################################

function isGitRepo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function setPS1Prompt {
  # Checks if your PWD is a git repo, and shows the update status in PS1
  local BLUE='\[$(tput setaf 6)\]'
  local BEIGE='\[$(tput setaf 222)\]'
  local GREEN='\[$(tput setaf 35)\]'
  local RED='\[$(tput setaf 124)\]'
  local PURPLE='\[$(tput setaf 140)\]'
  local BROWN='\[$(tput setaf 130)\]'
  local RESET='\[$(tput sgr0)\]'

  local prompt="$BLUE\u$BEIGE@$GREEN\h $RED: $PURPLE\W "


  if isGitRepo; then
    local BR="$(git rev-parse --abbrev-ref HEAD 2> /dev/null)"
    prompt+="$BROWN($BR "

    local ST=$(git status --short 2> /dev/null)
    local checkmark='\342\234\223'

    if [ -n "$ST" ];then
      prompt+="$RED+$BROWN) "
    else
      prompt+="$GREEN$checkmark$BROWN) "
    fi
  fi

  if [ $UID -eq 0 ]; then
    prompt+="$RED\# $RESET"
  else
    prompt+="$GREEN\\$ $RESET"
  fi
  PS1=$prompt
}

PROMPT_COMMAND='setPS1Prompt'

##################################################################
######################### Auto-update ############################
##################################################################

if [[ -f "$HOME/bin/dotfiles-update" ]]; then
  $HOME/bin/dotfiles-update
fi
