#!/bin/bash

function is-git-repo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

function git-is-clean {
  test -n "$(git status --porcelain)"
}

function get-github-username {
  local repo_remote_url
  repo_remote_url="$(git config get --local remote.origin.url)"

  if [[ $repo_remote_url =~ ^https://github\.com/([^/]+)/ ]] ||
     [[ $repo_remote_url =~ ^git@github\.com:([^/]+)/ ]]; then
    echo "${BASH_REMATCH[1]}"
    return 0
  fi

  echo "Remote URL '${repo_remote_url}' is not a valid https/ssh github url" >&2
  echo "" >&2
  echo "The URL should match one of the following:" >&2
  echo "    ^https://github\\.com/{username}/{repo}" >&2
  echo "    ^git@github\\.com:{username}/{repo}" >&2
  return 1
}

function get-default-branch {
  git config get --default main init.defaultbranch
}

function get-remote-name {
  local DEFAULT_BRANCH
  DEFAULT_BRANCH="$(get-default-branch)"
  git config get --local --default main "branch.${DEFAULT_BRANCH}.remote"
}

function new-branch {
  local NEW_BRANCH
  NEW_BRANCH="${1?"No branch specified"}"
  git branch "${NEW_BRANCH}"
  git checkout "${NEW_BRANCH}" || return 1
  git push -u "$(get-remote-name)" "${NEW_BRANCH}"
}

function get-pr-link {
  local GITHUB_USERNAME REPO_NAME TO_BRANCH FROM_BRANCH
  TO_BRANCH="${1:-$(get-default-branch)}"
  FROM_BRANCH="${2:-$(git rev-parse --abbrev-ref HEAD)}"
  GITHUB_USERNAME="$(get-github-username)"
  REPO_NAME="$(basename "$(git rev-parse --show-toplevel)")"
  echo "https://github.com/${GITHUB_USERNAME}/${REPO_NAME}/compare/${TO_BRANCH}...${FROM_BRANCH}"
}
