

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

alias vi=vim
if [[ -f "$(which vim.gtk3)" ]]; then
  # Has access to system clipboard
  alias vi=vim.gtk3
fi

# Read-only vim
alias svim="vi -M"

