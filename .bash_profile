

function append-path {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$PATH:$1" ;;
  esac
  export PATH
}

BASHRC_LOCAL="$HOME/.bashrc.local"

if [ -f "$BASHRC_LOCAL" ]; then
  export BASH_ENV="$BASHRC_LOCAL"
  . "$HOME/.bashrc.local"
fi

source ~/.bashrc  # for interactive login shells
