#!/bin/bash

# Install exa / create the $HOME/bin folder
if ! [ -f ~/exa ]; then
  curl -LSso ~/exa.zip https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip
  unzip ~/exa.zip -d ~/
  rm -rf ~/man ~/completions
  rm ~/exa.zip
fi

# Install ansi (easy use of control characters for terminal colors/styles)
if ! [ -f ~/bin/ansi ]; then
  curl -LSso ~/bin/ansi git.io/ansi
  chmod 0755 ~/bin/ansi
fi

# Deal with symlinking files
thisdir=~/dotfiles
files=$(cd $thisdir; ls -d .[a-z]* | grep -v .git$)
for file in $files; do
    ln -fs $thisdir/$file ~/$file
done

# Export github credentials for ~/.git-credentials 'store' credential helper
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
  gh_token="${GITHUB_TOKEN}"
fi

gh_cred="https://$gh_user:$gh_token@github.com"
echo $gh_cred > ~/.git-credentials

source ~/.bashrc

# Download vimconfig
git clone -q https://github.com/camratchford/vimconfig.git ~/vimconfig 2> /dev/null
~/vimconfig/plugin.sh





