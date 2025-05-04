#!/bin/bash

# Lists installed apt packages
# Options:
#   -d : Print package names and descriptions
#
function list-installed {
  local FMT='${Package}\n'

  if [ "$1" == "-d" ]; then
      FMT="$(ansi --inverse '${Package}' )\n$(ansi --reset-color '${Description}')\n\n"

  fi
  dpkg-query -f="$FMT" -W | sed "s/^\s\.//" | sed "s/^\s//"
}

# Returns 0 if package is installed, returns 1 if it is not installed
# Args:
#   $1 : The package you want to know the status of
#
function is-installed {
  list-installed | grep -q "$1" > /dev/null
}

function get-installed {
  FMT="$(ansi --inverse '${Package}' )\n\n$(ansi --reset-color '${Description}')\n\n"
  dpkg-query -f="$FMT" -W $1 | sed "s/^\s\.//" | sed "s/^\s//"

}
