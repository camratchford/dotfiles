#!/bin/bash

function list-installed {
  # Lists installed apt packages
  local FMT='${Package}\n'
  if [ "${1:-""}" == "-d" ]; then
      FMT="$(ansi --inverse '${Package}' )\n$(ansi --reset-color '${Description}')\n\n"
  fi
  dpkg-query -f="$FMT" -W | sed "s/^\s\.//" | sed "s/^\s//"
}

function is-installed {
  # Returns 0 if package is installed, returns 1 if it is not installed
  list-installed | grep -q "$1" > /dev/null
}

function get-installed {
  # List installed apt packages, Gets the info on $1 if $1 is supplied
  FMT="$(ansi --inverse '${Package}' )\n\n$(ansi --reset-color '${Description}')\n\n"
  dpkg-query -f="$FMT" -W $1 | sed "s/^\s\.//" | sed "s/^\s//"
}

function list-package-sections {
   # Lists all installed packages with their section (package category) name
   FMT='${Package}\t${Section}\n'
   dpkg-query -f="$FMT" -W $1 | sed "s/^\s\.//" | sed "s/^\s//" | column -t -s $'\t'
}

function list-package-last-mod {
  # Lists all manually installed packages with the epoch of their last modified date
  FMT='${Package}\t${db-fsys:Last-Modified}\n'

  for package in $(apt-mark showmanual); do
    dpkg-query -f="$FMT" -W $package | column --table --columns 2
  done

}
