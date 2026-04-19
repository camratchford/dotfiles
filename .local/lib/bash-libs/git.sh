#!/bin/bash

function new-branch {
  local BRANCH="${1?"No branch specified"}"
  git branch "${BRANCH}"
  git checkout "${BRANCH}" || return 1
  git push -u origin "${BRANCH}"
}
