#!/bin/bash

function gh-export-credentials {
  local GIT_CREDENTIALS_CONTENT GIT_CREDENTIALS_FILE GH_CRED_REGEX
  GIT_CREDENTIALS_FILE=${1:-"$HOME/.git-credentials"}

  if ! which gh &> /dev/null ; then
    echo "gh is not installed"
    return 1
  fi

  if ! [ -f "$GIT_CREDENTIALS_FILE" ]; then
    echo "Could not find ${GIT_CREDENTIALS_FILE} file"
    exit 1
  fi

  GIT_CREDENTIALS_CONTENT=$(< "$GIT_CREDENTIALS_FILE")
  GH_CRED_REGEX="(https:\/\/)([a-zA-Z0-9_-]*)(:)([a-zA-Z0-9_]*)(\@github\.com)"
  if [[ $GIT_CREDENTIALS_CONTENT =~ $GH_CRED_REGEX ]]; then
    GH_USERNAME="${BASH_REMATCH[2]}"
    GH_TOKEN="${BASH_REMATCH[4]}"
    export GH_USERNAME="${GH_USERNAME}"
    export GH_TOKEN="${GH_TOKEN}"
  fi
}

function gh-login {
  if ! which gh &> /dev/null ; then
    echo "gh is not installed"
    return 1
  fi

  gh-export-credentials && gh auth login --hostname github.com
}

function gh-new-repo {
  local SOURCE
  SOURCE="${1:-"$PWD"}"

  if [[ $# -gt 1 ]]; then
    shift
  fi

  if ! which gh &> /dev/null ; then
    echo "gh is not installed"
    return 1
  fi

  if [ ! -d "$SOURCE/.git" ]; then
    git init "$SOURCE"
  fi

  gh repo create --private --source="$SOURCE" --remote=upstream "$@"
}
