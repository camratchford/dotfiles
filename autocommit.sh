#!/bin/bash
SCRIPT_NAME="$(realpath $0)"
if [[ "$UID" == "0" ]]; then
    /usr/bin/logger -t ERROR -i "Script: [$SCRIPT_NAME should] not be run as root."
    exit 1
fi


THIS_DIR="$(dirname $SCRIPT_NAME)"
DEFAULT_BRANCH="$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')"
cd $THIS_DIR


function LogCmdExec() {
    CMD=$1
    ERR="$(exec $CMD 2>&1 > /dev/null)"
    if [ "$ERR" != "" ]; then
        logger -t ERROR -i "$SCRIPT_NAME : $ERR"
        logger -t ERROR -i "$SCRIPT_NAME : $CMD"
    fi
}


LogCmdExec "git add -A"
LogCmdExec 'git commit -m "Autocommit"'
LogCmdExec "git push -f origin $DEFAULT_BRANCH"


#{ git add . 2>&3 | /dev/null; } 3>&1 | logger -t ERROR -i
#{ git commit -m "Autocommit $(date)" 2>&3 | /dev/null; } 3>&1 | logger -t ERROR -i
#{ git push -f origin "$DEFAULT_BRANCH" 2>&3 | /dev/null; } 3>&1 | logger -t ERROR -i






