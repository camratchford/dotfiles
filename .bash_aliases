
# Configure exa to replace ls and set up desired LS_COLORS
if [[ -f "$HOME/.local/bin/exa" ]]; then
  alias ls="exa --long --icons --group-directories-first --no-permissions --octal-permissions --git"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export EXA_COLORS="$LS_COLORS"
fi

# Standard ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi


# Various handy python commands
if [[ -f "/usr/bin/python3" ]]; then
  alias python="/usr/bin/python3"
  alias http="python -m http.server"
  alias json="python -m json.tool"
  alias venv="python -m venv"
fi

if [[ -f "$(which lxd)" ]]; then
  alias lls="lxd ls"
fi

alias vi=vim
if [[ -f "$(which nvim)" ]]; then
  alias vi=nvim
fi
