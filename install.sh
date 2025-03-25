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


function link-dir {
    local src="$1"
    local target="$2"
    mkdir -p "$(dirname "$(realpath "$target")")"
    ln -fs "$src" "$target" 2> /dev/null
}

SYMLINK_DIRS=("$THISDIR/bin:$HOME/" "$THISDIR/.vim:$HOME/" "$THISDIR/.local/lib/bash-libs:$HOME/.local/lib/" "$THISDIR/.config/nvim:$HOME/.config/")

# Deal with symlinking files
DOTFILES=$(find "$THISDIR" -maxdepth 1 -type f -name ".*")
for file in $DOTFILES; do
  file_name=$(echo "$file" | sed "s|^$THISDIR/||")
  ln -fs "$file" "$HOME/$file_name"
done


if ! [[ -f "$HOME/.local/bin" ]]; then
  curl -sfLo "$HOME/.local/bin/ansi" https://raw.githubusercontent.com/fidian/ansi/refs/heads/master/ansi
  chmod +x "$HOME/.local/bin/ansi"
fi

if [ "$(dpkg-query -f='${Package}\n' -W unzip 2> /dev/null;)" == "" ]; then
    echo "Unable to install exa as unzip is not installed."
    echo "Please run: sudo apt install -y unzip"
else
  if ! [ -f "$HOME/.local/bin/exa" ]; then
    # This version supports the '--git' and '--git-ignore' flags, which are awfully handy in tree mode
    # Alternatively, use the apt package
    curl -sfLo "$HOME/exa/exa.zip" --create-dirs https://github.com/ogham/exa/releases/download/v0.10.1/exa-linux-x86_64-v0.10.1.zip
    unzip -d "$HOME/exa" "$HOME/exa/exa.zip"
    install -Dm755 "$HOME/exa/bin/exa" "$HOME/.local/bin"
    install -Dm644 "$HOME/exa/completions/exa.bash" "$HOME/.local/share/bash-completion/completions/exa"
    install -Dm644 "$HOME/exa/completions/exa.fish" "$HOME/.local/share/fish/completions/exa.fish"
    install -Dm644 "$HOME/exa/completions/exa.zsh" "$HOME/.local/share/zsh/site-functions/_exa"
    install -Dm644 "$HOME/exa/man/exa.1" "$HOME/.local/share/man/man1/exa.1"
    install -Dm644 "$HOME/exa/man/exa_colors.5" "$HOME/.local//share/man/man5/exa_colors.5"
    rm -rf "$HOME/exa"
  fi
fi

for src_target in "${SYMLINK_DIRS[@]}"; do
  IFS=":" read -r src target <<< "$src_target"
  link-dir "$src" "$target"
done

if [[ -f "$(which nvim)" ]]; then
  if ! $(check-nvim-verison 2>&1 > /dev/null); then
    echo "Neovim version must be at least 0.8.0 for the plugins to load correctly. Use the snap version of nvim (not apt)" 1>&2
    exit 1
  fi
  sh -c 'curl -sfLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim --headless PlugInstall +qall 2>&1 > /dev/null
fi


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

if [ -f "$HOME/.git-credentials" ]; then
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
