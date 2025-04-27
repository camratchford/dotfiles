#!/bin/bash

# Args:
#   $1 = URL
function execurl {
  bash <(curl -s $1)
}

# Executes tput commands to remove the previous row of terminal text
function del-prev-line {
  tput cuu1 && tput el
}


# Reads the first line in a file into a variable (found in /usr/lib/git-core/git-sh-prompt as '__git_eread')
# Args:
#   $1 = path of the file whose header you'd like to store
#   $2 = name of the variable in which you'd like to store the header

function read-file-header {
  test -r "$1" && IFS=$'\r\n' read "$2" <"$1"
}

