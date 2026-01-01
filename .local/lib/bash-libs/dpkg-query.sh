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


function list-package-sections {
   FMT='${Package}\t${Section}\n'
   dpkg-query -f="$FMT" -W $1 | sed "s/^\s\.//" | sed "s/^\s//" | column -t -s $'\t'
}



function list-package-last-mod {
  FMT='${Package}\t${db-fsys:Last-Modified}\n'

  for package in $(apt-mark showmanual); do
    dpkg-query -f="$FMT" -W $package | column --table --columns 2
  done

}
