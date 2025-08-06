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

function xfce-notify {
  title="${1? "You must supply a title"}"
  msg="${2? "You must supply a message"}"
  export DISPLAY=:0
  export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS /proc/$(pgrep -u "$USER" xfce4-session)/environ | sed -e 's/DBUS_SESSION_BUS_ADDRESS=//')

  /usr/bin/notify-send "$title" "$msg"
}
