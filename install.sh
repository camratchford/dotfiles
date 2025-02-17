#!/bin/bash -i

THISDIR="$(dirname $(realpath $0))"

function check-nvim-verison  {
   local CURVER="$(nvim -v | sed -n '1p' | awk '{print $2} ' | grep -o -P "([0-9]{1,2})")"
   local CURVER_ARRAY=($CURVER)

   local MAJOR="${CURVER_ARRAY[0]}"
   local MINOR="${CURVER_ARRAY[1]}"
   if [[ $MAJOR -gt 0 ]] || { [[ $MAJOR -eq 0 ]] && [[ $MINOR -ge 8 ]]; }; then
     exit 0
   fi
   exit 1
}

# Deal with symlinking files
DOTFILES=$(find "$THISDIR" -maxdepth 1 -type f -name ".*")
for file in $DOTFILES; do
  file_name=$(echo "$file" | sed "s|^$THISDIR/||")
  ln -fs "$file" "$HOME/$file_name"
done

if [[ -d "$HOME/.local/bash-libs" ]]; then
    rm -rf "$HOME/.local/bash-libs"
fi
ln -fs "$THISDIR/bash-libs" "$HOME/.local/lib"

if [[ -f "$(which nvim)" ]]; then
  if ! $(check-nvim-verison 2>&1 > /dev/null); then
    echo "Neovim version must be at least 0.8.0 for the plugins to load correctly. Use the snap version of nvim (not apt)" 1>&2
    exit 1
  fi

  mkdir -p "$HOME/.config"
  if [ -L "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
  fi
  ln -fs "$THISDIR/nvim" "$HOME/.config"
  sh -c 'curl -sfLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim --headless PlugInstall +qall 2>&1 > /dev/null
fi

if ! [[ -f "$(which ansi)" ]]; then
  curl -sfLo "$HOME/dotfiles/bin/ansi" https://raw.githubusercontent.com/fidian/ansi/refs/heads/master/ansi
  chmod +x ansi
fi

ln -fs "$HOME/dotfiles/bin" "$HOME/"
ln -fs "$HOME/dotfiles/.vim" "$HOME/"


# Export github credentials for ~/.git-credentials 'store' credential helper
if [[ -z "$GITHUB_USERNAME" ]]; then
  echo -e "Please provide your GitHub username:"
  read -t 5 gh_user && tput cuu1 && tput el
else
  gh_user="${GITHUB_USERNAME}"
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo -e "Please provide your GitHub token:"
  stty -echo
  read -t 5 gh_token && tput cuu1 && tput el
  stty echo
else
  gh_token="${GITHUB_TOKEN}"
fi

if [ -L "$HOME/.git-credentials" ]; then
  rm -f "$HOME/.git-credentials"
fi

if [[ -n "$gh_user" ]] && [[ -n "$gh_token" ]]; then
  gh_cred="https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com"
  echo $gh_cred > "$HOME/.git-credentials"
fi

if [[ $(stat -c "%a" "$HOME/.git-credentials") -ne 600 ]]; then
  chmod 600 "$HOME/.git-credentials"
fi
. "$HOME/.bashrc"
echo complete
