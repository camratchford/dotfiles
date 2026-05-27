
# Standard ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

# Various handy python commands
alias http="python3 -m http.server"
alias json="python3 -m json.tool"
alias venv="python3 -m venv"

# vi is shorter than vim
alias vi=vim
# Has clipboard support
which vim.gtk3 &> /dev/null && alias vi=vim.gtk3

export EDITOR="vi"

# ls clone, depending on what's available
if which eza &> /dev/null ; then
  alias ls="eza"
  alias ll="eza --all --long --icons --group-directories-first --no-permissions --octal-permissions --git"
  alias tree="eza --all --group-directories-first -F --tree"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  export LS_COLORS=$( < ~/.LS_COLORS)
  export EZA_COLORS="$LS_COLORS"
elif which exa &> /dev/null ; then
  alias ls="exa"
  EXA_ARGS="--long --all --icons --group-directories-first --no-permissions --octal-permissions"
  if [[ "$(exa --version | grep -c "\[-git\]")" == "0" ]]; then
    EXA_ARGS="$EXA_ARGS --git"
  fi
  alias ll="exa $EXA_ARGS"
  alias tree="exa --force --group-directories-first -F --tree"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export LS_COLORS
  export EXA_COLORS="$LS_COLORS"
fi

# cat clone
if which batcat &> /dev/null ; then
   alias cat="batcat"
   alias gcat="/usr/bin/cat"
   export BAT_THEME="TwoDark"
   # No line numbers, easy copy & paste
   export BAT_STYLE="plain"
fi

# log file viewer / tail -f replacement
if which lnav &> /dev/null ; then
   function tail {
    if [[ "$1" == "-f" ]]; then
        lnav "$@"
    else
        /usr/bin/tail "$@"
    fi
   }
   export -f tail
fi

# less clone
if which most &> /dev/null; then
  export PAGER="most"
  alias less="most"
fi

function vim-sh {
  vim -c 'setfiletype sh' $@
}
export FCEDIT="vim-sh"

# Edit the last command in HISTORY, then execute
alias e='fc -nr 0'
# Re-run the last command in HISTORY
alias r='fc -s'

alias p=""

