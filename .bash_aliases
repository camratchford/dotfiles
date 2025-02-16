

if [[ -f "$(which exa)" ]]; then
  alias ls="exa --long --icons --group-directories-first --no-permissions --octal-permissions"
  # Set the 24bit colors I want exa to use
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export EXA_COLORS="$LS_COLORS"
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Add an "alert" alias for long running commands.  Use like so:
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

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
