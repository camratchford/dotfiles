#!/bin/bash

WHITE='\[$(tput setaf 15)\]'
BLUE='\[$(tput setaf 6)\]'
BEIGE='\[$(tput setaf 221)\]'
GREEN='\[$(tput setaf 35)\]'
RED='\[$(tput setaf 124)\]'
LIGHT_RED='\[$(tput setaf 203)\]'
PURPLE='\[$(tput setaf 140)\]'
BROWN='\[$(tput setaf 248)\]'
RESET='\[$(tput sgr0)\]'

function is-git-repo {
  git rev-parse --is-inside-work-tree &> /dev/null
}

# Build git status line
function get-status-line {
  local STATUS_LINE=""
  local CHECK='\342\234\223'
  local FILE_STATUS="$(git status --short 2>/dev/null)"
  local BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"

  if git show-ref --quiet refs/remotes/origin/main; then
    local MAIN_AHEAD_BEHIND=($(git rev-list --left-right --count origin/main...HEAD 2>/dev/null))
    local BEHIND_MAIN="${MAIN_AHEAD_BEHIND[0]}"
    local AHEAD_MAIN="${MAIN_AHEAD_BEHIND[1]}"

    (( AHEAD_MAIN > 0 )) && STATUS_LINE+="${PURPLE}⇑${AHEAD_MAIN}${RESET} "
    (( BEHIND_MAIN > 0 )) && STATUS_LINE+="${PURPLE}⇓${BEHIND_MAIN}${RESET} "
  fi

  if git rev-parse --abbrev-ref --symbolic-full-name @{u} &>/dev/null; then
    local BRANCH_AHEAD_BEHIND=($(git rev-list --left-right --count @{u}...HEAD 2>/dev/null))
    local BEHIND_BRANCH="${BRANCH_AHEAD_BEHIND[0]}"
    local AHEAD_BRANCH="${BRANCH_AHEAD_BEHIND[1]}"

    (( AHEAD_BRANCH > 0 )) && STATUS_LINE+="${BLUE}↑${AHEAD_BRANCH}${RESET} "
    (( BEHIND_BRANCH > 0 )) && STATUS_LINE+="${BLUE}↓${BEHIND_BRANCH}${RESET} "
  fi

  local ADDED=0
  local DELETED=0
  local MODIFIED=0
  local UNTRACKED=0

  while IFS= read -r line; do
    status="${line:0:2}"  # first two chars

    case "$status" in
      \?\?) ((UNTRACKED++)) ;;
      *A* ) ((ADDED++)) ;;
      *D* ) ((DELETED++)) ;;
      *M* ) ((MODIFIED++)) ;;
    esac
  done <<< "$FILE_STATUS"

  (( ADDED > 0 ))     && STATUS_LINE+="${LIGHT_RED}+${ADDED}${RESET}"
  (( DELETED > 0 ))   && STATUS_LINE+="${LIGHT_RED}-${DELETED}${RESET}"
  (( MODIFIED > 0 ))  && STATUS_LINE+="${LIGHT_RED}~${MODIFIED}${RESET}"
  (( UNTRACKED > 0 )) && STATUS_LINE+="${LIGHT_RED}?${UNTRACKED}${RESET}"

  [[ -z "$FILE_STATUS" ]] && STATUS_LINE+="${GREEN}${CHECK}${RESET}"

  echo "$BROWN[$BEIGE$BRANCH ${STATUS_LINE}$WHITE$BROWN] "
}

function set-ps1-prompt {
  local prompt="$BLUE\u$BEIGE@$GREEN\h$RED : $PURPLE\W ${RESET}"
  if is-git-repo; then
    local STATUS_LINE="$(get-status-line)"
    prompt+="$STATUS_LINE"
  fi

  if [[ $UID -eq 0 ]]; then
    prompt+="$RED\\$ $RESET"
  else
    prompt+="$GREEN\\$ $RESET"
  fi

  PS1=$prompt
}

PROMPT_COMMAND='set-ps1-prompt'

