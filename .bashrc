#############################################################################
###################### Standard Ubuntu bashrc stuff #########################
#############################################################################

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

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
  fi
fi


########################################################################
###################### declare / set variables #########################
########################################################################

export PATH="/sbin:/usr/sbin:/usr/local/bin:/$HOME/bin:~/.local/bin:/snap/bin:$PATH"
export EDITOR=/usr/bin/vim
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
if which exa >/dev/null; then
  alias ls="$HOME/bin/exa --long --git --icons --group-directories-first --no-permissions --octal-permissions"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  sudo touch /tmp/lscolors && sudo chmod 777 /tmp/lscolors
  env LS_COLORS="$LS_COLORS" 2>&1 /tmp/lscolors # /dev/null doesn't work in lxd
fi
if which fd 2>&1 > /dev/null; then
  alias find="$HOME/bin/fd"
fi
#alias less="/usr/share/vim/vim82/macros/less.sh"
alias python="/usr/bin/python3"

##############################################################################
###################### dot-sourcing / sourcing files #########################
##############################################################################

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Import .bashrc.* files if they exists



##################################################################
###################### set prompt colors #########################
##################################################################

if [ $UID -eq 0 ]; then
        PS1="\[\033[38;5;6m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;79m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;1m\]:\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;140m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;196m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
else
        PS1="\[\033[38;5;6m\]\u\[$(tput sgr0)\]@\[$(tput sgr0)\]\[\033[38;5;79m\]\h\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;1m\]:\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;140m\]\W\[$(tput sgr0)\] \[$(tput sgr0)\]\[\033[38;5;10m\]\\$\[$(tput sgr0)\] \[$(tput sgr0)\]"
fi


######################################################################
###################### convenience functions #########################
######################################################################

# For reckless invocations of scripts piped directly into bash
function execurl {
  bash <(curl -s $1)
}

# For expelling the errant know_hosts file entries when you've rebuilt a host
function newsshhost {
  ssh-keygen -f ~/.ssh/known_hosts -R $1
  ip=$(grep $1 /etc/hosts | awk '{print $1}')
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ip=$(dig -t a +short $1)
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ip=$(dig -t aaaa +short $1)
  if [[ -n $ip ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R $ip
  fi
  ssh-keyscan -t ecdsa $1 >> ~/.ssh/known_hosts
}

# For easy git syncing
function update() {
    git fetch
    git pull
}

