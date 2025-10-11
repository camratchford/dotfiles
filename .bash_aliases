
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
if [[ -f "/usr/bin/python3" ]]; then
  alias python="/usr/bin/python3"
  alias http="python -m http.server"
  alias json="python -m json.tool"
  alias venv="python -m venv"
fi

# vi is shorter than vim
alias vi=vim
# Has clipboard support
[[ -f "$(which vim.gtk3)" ]] && alias vi=vim.gtk3
# Read-only vim
alias svim="vi -M"
export EDITOR="vi"

# ls clone, depending on what's available
if [[ -f "$(which eza)" ]]; then
  alias ls="eza"
  alias ll="eza --all --long --icons --group-directories-first --no-permissions --octal-permissions --git"
  alias tree="eza -F --tree"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export LS_COLORS
  export EZA_COLORS="$LS_COLORS"
elif [[ -f "$(which exa)" ]]; then
  alias ls="exa"
  EXA_ARGS="--long --all --icons --group-directories-first --no-permissions --octal-permissions"
  if [[ "$(exa --version | grep -c "\[-git\]")" == "0" ]]; then
    EXA_ARGS="$EXA_ARGS --git"
  fi
  alias ll="exa $EXA_ARGS"
  alias tree="exa -F --tree"
  tr '\n' ':' < ~/.lscolors > ~/.LS_COLORS
  LS_COLORS=$(< ~/.LS_COLORS)
  export LS_COLORS
  export EXA_COLORS="$LS_COLORS"
fi

# cat clone
if [[ -f "$(which batcat)" ]]; then
   alias cat="batcat"
   export BAT_THEME="TwoDark"
   # No line numbers, easy copy & paste
   export BAT_STYLE="plain"
fi

# less clone
if [[ -f "$(which most)" ]]; then
  export PAGER="most"
  alias less="most"
fi

# Allow pycharm to open in the background when invoked from the shell
if [[ -f "$(which pycharm)" ]]; then
  function pycharm {
    $(which pycharm) $@ &> /dev/null &
  }
fi

# Re-run the last command in HISTORY
alias r='fc -s'


BACKUPS_DEFAULT_PATHFILE="~/.backup-paths"
BACKUPS_DEFAULT_EXCLUDEFILE="~/.backup-exclude"

alias gh-login="export-gh-creds && gh auth login --hostname github.com"
