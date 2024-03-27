#!/bin/bash


# Deal with symlinking files
thisdir=~/dotfiles
files=$(cd $thisdir; ls -d .[a-z]* | grep -v .git$)
for file in $files; do
    ln -fs $thisdir/$file ~/$file
done

if [ $(which nvim) ]; then
  mkdir -p ~/.config/nvim/
  ln -fs $thisdir/nvim_init.vim ~/.config/nvim/init.vim
fi

ln -fs ~/dotfiles/bin ~/bin

# Export github credentials for ~/.git-credentials 'store' credential helper

if [[ -z "${GITHUB_USER}" ]]; then
  echo "Please provide your github username:"
  timeout 10 read gh_user
else
  gh_user="${GITHUB_USER}"
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "Please provide your github access token:"
  timeout 10 read gh_token
else
  gh_token="${GITHUB_TOKEN}"
fi

gh_cred="https://$gh_user:$gh_token@github.com"
echo $gh_cred > ~/.git-credentials

source ~/.bashrc


