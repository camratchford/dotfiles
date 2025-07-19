#!/bin/bash

# Logs the text to STDERR in red, formatted with the date.
# Args:
#   $* = Error Message
#

function err {
  err_format="[$(date +'%Y-%m-%dT%H:%M:%S%z')]:"
  ansi --red "${err_format} $*" >&2
}

function logcmdexec() {
  set -euo pipefail

  local HELP=$(cat <<EOF
  Usage: logcmdexec CMD

  Executes the given command and logs to syslog
   - Logs the successful execution of a command to syslog with the severity INFO if RC = 0
   - Logs the contents of STDERR with severity ERROR if RC != 0

  Example:
    # Single-quoted string, allowing variable expansion on execution (otherwise, escape variables)
    logcmdexec 'rsync -avh /home/cam cam@storage:/backups/\$HOSTNAME/'
EOF
)
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --help)
        printf "%s\n" "$HELP" && return 0
        shift
        ;;
      *)
        break
        ;;
    esac
  done
  local COMMAND="${1?"Missing CMD argument"}"
  local CALLER_INFO="$(caller 0)"
  local LINE_NO="$(echo "$CALLER_INFO" | awk '{print 1}')"
  local FUNC_NAME="$(echo "$CALLER_INFO" | awk '{print 2}')"
  local SCRIPT_PATH="$(realpath "$(echo "$CALLER_INFO" | awk '{print 3}')")"

  local ERR="$(eval $COMMAND 2>&1 > /dev/null)"
  if [ $? != "0" ]; then
    /usr/bin/logger -t ERROR -i "$SCRIPT_PATH:$SCRIPT_NAME:$LINE_NO - $ERR"
    return 1
  fi

  /usr/bin/logger -t INFO -i "$SCRIPT_PATH:$SCRIPT_NAME:$LINE_NO - Completed successfully"
}
