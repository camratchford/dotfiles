#!/bin/bash -i

function search-history {
  PROMPT="Search history: "
  read -re -p "$PROMPT" QUERY

  tput cuu1 && tput el
  HISTORYFILE="$HOME/.bash_history"
  MATCHES="$(grep "$QUERY" "$HISTORYFILE" || /bin/true)"
  echo "$MATCHES"
}

