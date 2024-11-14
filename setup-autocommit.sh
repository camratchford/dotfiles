#!/bin/bash

if [[ $UID != "0" ]]; then
    echo "Must be run with sudo"
    exit 1
fi

REPO_NAME="$(basename $(git rev-parse --show-toplevel))"
THIS_DIR="$(dirname $(realpath $0))"
AUTOCOMMIT="$THIS_DIR/autocommit.sh"
CRON_SCRIPT_PATH="/etc/cron.hourly/$REPO_NAME-autocommit.sh"

touch "$CRON_SCRIPT_PATH"
echo "#!/bin/bash" > "$CRON_SCRIPT_PATH"
echo "runuser -u $(logname) $AUTOCOMMIT" >> "$CRON_SCRIPT_PATH"
echo "exit 0" >> "$CRON_SCRIPT_PATH"
chmod 777 "$CRON_SCRIPT_PATH"

