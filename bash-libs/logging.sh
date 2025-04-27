#!/bin/bash

# Logs the text to STDERR in red, formatted with the date.
# Args:
#   $* = Error Message
#

function err {
  err_format="[$(date +'%Y-%m-%dT%H:%M:%S%z')]:"
  ansi --red "${err_format} $*" >&2
}

# Executes the given command and logs to syslog
#  - Logs the successful execution of a command to syslog with the severity INFO if RC = 0
#  - Logs the contents of STDERR with severity ERROR if RC != 0
# Args:
#   $1 = Command to execute
#
function logcmdexec() {
  local CALLER_INFO="$(caller 0)"
  local LINE_NO="$(echo "$CALLER_INFO" | awk '{print 1}')"
  local FUNC_NAME="$(echo "$CALLER_INFO" | awk '{print 2}')"
  local SCRIPT_PATH="$(realpath "$(echo "$CALLER_INFO" | awk '{print 3}')")"

  local ERR="$(eval $CMD 2>&1 > /dev/null)"
  if [ $? != "0" ]; then
    /usr/bin/logger -t ERROR -i "$SCRIPT_PATH:$SCRIPT_NAME:$LINE_NO - $ERR"
    exit
  fi

  /usr/bin/logger -t INFO -i "$SCRIPT_PATH:$SCRIPT_NAME:$LINE_NO - Completed successfully"
}
