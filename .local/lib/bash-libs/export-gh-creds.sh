#!/bin/bash

function export-gh-creds {
  local GIT_CREDENTIALS_FILE="${HOME}/.git-credentials"
  if ! [ -f $GIT_CREDENTIALS_FILE ]; then
    echo "Could not find ${GIT_CREDENTIALS_FILE} file"
    exit 1
  fi

  local GIT_CREDENTIALS_CONTENT=$(< $GIT_CREDENTIALS_FILE)
  local GH_CRED_REGEX="(https:\/\/)([a-zA-Z0-9_-]*)(:)([a-zA-Z0-9_]*)(\@github\.com)"
  if [[ $GIT_CREDENTIALS_CONTENT =~ $GH_CRED_REGEX ]]; then
    GH_USERNAME="${BASH_REMATCH[2]}"
    GH_TOKEN="${BASH_REMATCH[4]}"
    export GH_USERNAME="${GH_USERNAME}"
    export GH_TOKEN="${GH_TOKEN}"
  fi
}

