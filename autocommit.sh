#!/bin/bash
SCRIPT_NAME="$(realpath $0)"
if [ "$UID" == "0" ]; then
    /usr/bin/logger -t ERROR -i "Script: [$SCRIPT_NAME should] not be run as root."
    exit 1
fi

THIS_DIR="$(dirname $SCRIPT_NAME)"
DEFAULT_BRANCH="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
cd "$THIS_DIR"

function LogCmdExec() {
    CMD="$1"
    ERR="$(eval $CMD 2>&1 > /dev/null)"
    if [ $? != "0" ]; then
        /usr/bin/logger -t ERROR -i "$SCRIPT_NAME : $ERR"
        /usr/bin/logger -t ERROR -i "$SCRIPT_NAME : $CMD"
    fi
}

LogCmdExec "git add -A"
LogCmdExec 'git commit -m "Autocommit $(date)"'
LogCmdExec "git push -f origin $DEFAULT_BRANCH"
