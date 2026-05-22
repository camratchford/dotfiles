# Called first for interactive login shells

if [[ -f "$HOME/.bashrc" ]]; then
  source "$HOME/.bashrc"
fi
