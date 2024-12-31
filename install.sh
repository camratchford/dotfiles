#!/bin/bash

SCRIPT_DIR="$(dirname $(realpath $0))"
TIMEOUT_READ="${SCRIPT_DIR}/bin/timeout_read"
if ! [ -f $TIMEOUT_READ ]; then
    echo "Could not find timeout_read script"
    exit 1
fi


# Deal with symlinking files
thisdir="$SCRIPT_DIR"
files=$(cd $thisdir; ls -d .[a-z]* | grep -v .git$)
for file in $files; do
    ln -fs $thisdir/$file ~/$file
done

if [ $(which nvim) ]; then
  mkdir -p ~/.config
  ln -fs $thisdir/nvim ~/.config
  sh -c 'curl -sfLo "$HOME/.local/share/nvim/site/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  nvim --headless +PlugInstall +qall 2> /dev/null
fi

pushd ~/dotfiles/bin 1> /dev/null 2> /dev/null
if ! [ -f ansi ]; then
  wget --quiet https://raw.githubusercontent.com/fidian/ansi/refs/heads/master/ansi
  chmod +x ansi
  popd 1> /dev/null 2> /dev/null
fi
ln -fs ~/dotfiles/bin ~/
ln -fs ~/dotfiles/.vim ~/


# Export github credentials for ~/.git-credentials 'store' credential helper

if [[ -z "$GITHUB_USERNAME" ]]; then
  echo "Please provide your github username:"
  gh_user=$($TIMEOUT_READ 10)
else
  gh_user="${GITHUB_USERNAME}"
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Please provide your github access token:"
  gh_token=$($TIMEOUT_READ 10)
else
  gh_token="${GITHUB_TOKEN}"
fi

gh_cred="https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com"
echo $gh_cred > ~/.git-credentials
echo complete
