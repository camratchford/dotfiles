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
  mkdir -p ~/.config/nvim/
  ln -fs $thisdir/nvim_init.vim ~/.config/nvim/init.vim
fi

ln -fs $(realpath ~/dotfiles/bin) $(realpath ~/bin)

# Export github credentials for ~/.git-credentials 'store' credential helper

if [[ -z "$GITHUB_USERNAME" ]]; then
  echo "Please provide your github username:"
  gh_user=$($TIMEOUT_READ 10)
else
  gh_user="${GITHUB_USER}"
fi

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "Please provide your github access token:"
  gh_token=$($TIMEOUT_READ 10)
else
  gh_token="${GITHUB_TOKEN}"
fi

gh_cred="https://$gh_user:$gh_token@github.com"
echo $gh_cred > ~/.git-credentials
echo complete
