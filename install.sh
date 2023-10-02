#!/bin/bash

# Install exa / create the $HOME/bin folder
curl -LSso ~/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
unzip ~/exa.zip -d ~/
rm -rf ~/man ~/completions
rm ~/exa.zip

# Deal with the git files
thisdir=~/dotfiles
files=$(cd $thisdir; ls -d .[a-z]* | grep -v .git$)

# Create symlink for each file/folder
for file in $files; do
    ln -fs $thisdir/$file ~/$file
done

if [[ -z "${GITHUB_USER}" ]]; then
  echo "Please provide your github username:"
  read gh_user
else
  gh_user="${GITHUB_USER}"
fi

if [[ -z "${GITHUB_TOKEN}" ]]; then
  echo "Please provide your github access token:"
  read gh_token
else
  gh_user="${GITHUB_USER}"
fi

gh_cred="https://$gh_user:$gh_token@github.com"
echo $GH_CRED > ~/.git-credentials

source ~/.bashrc

# Download vimconfig
git clone -q https://github.com/camratchford/vimconfig.git ~/ 2> /dev/null
~/vimconfig/plugin.sh





