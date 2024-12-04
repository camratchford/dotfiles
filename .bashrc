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

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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


##################################################################
###################### Alias definitions #########################
##################################################################

alias http='python3 -m http.server'
alias json='python3 -m json.tool'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# LXC aliases
alias lls="lxc ls"

# Override some gnu tools with alternatives
EXA_PATH="$(which exa)"
if [ -f "$EXA_PATH" ]; then
  alias ls="$EXA_PATH --long --icons --group-directories-first --no-permissions --octal-permissions"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export EXA_COLORS="$LS_COLORS"
fi

if [ $(which fd) ]; then
  alias find="$HOME/bin/fd"
fi
alias python="/usr/bin/python3"

alias vi=vim
if [ -f "$(which nvim)" ]; then
  alias vi=nvim
  export EDITOR=/usr/bin/nvim
fi

##############################################################################
###################### dot-sourcing / sourcing files #########################
##############################################################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Import .bashrc.local if it exists
if [ -f ~/.bashrc.local ]; then
    . ~/.bashrc.local
fi

# Import bashrc.lib if it exists
if [ -f ~/.bashrc.lib ]; then
    . ~/.bashrc.lib
fi

gh_token=$(cat ~/.git-credentials | grep -P "ghp_[A-Za-z0-9]*" -o)
if [ "$gh_token" ]; then
  export GITHUB_TOKEN="${gh_token}"
fi

gh_username=$(cat ~/.git-credentials | grep -P "(?<=\/\/{1})[a-z\-]*(?=:{1})" -o)
if [ "$gh_username" ]; then
  export GITHUB_USERNAME="${gh_username}"
fi


##################################################################
###################### set prompt colors #########################
##################################################################

function is_git_repo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function set_prompt {
  local BLUE='\[$(tput setaf 6)\]'
  local BEIGE='\[$(tput setaf 222)\]'
  local GREEN='\[$(tput setaf 35)\]'
  local RED='\[$(tput setaf 124)\]'
  local PURPLE='\[$(tput setaf 140)\]'
  local BROWN='\[$(tput setaf 130)\]'
  local RESET='\[$(tput sgr0)\]'

  local prompt="$BLUE\u$BEIGE@$GREEN\h $RED: $PURPLE\W "
  # optional(gitprompt)(uid_symbol)

  if is_git_repo; then
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

PROMPT_COMMAND='set_prompt'

$HOME/bin/dotfiles-update

# add Pulumi to the PATH
export PATH=$PATH:/home/cam/.pulumi/bin
