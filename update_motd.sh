#!/bin/bash
check_root
function update_motd() {
    UPDATE_MOTD="/etc/update-motd.d"
    rm -rf "$UPDATE_MOTD/{*,.*}"
    # Expand tar.gz
    tar -xzvf update-motd.tar.gz -C /
}

ynprompt -p "This script will delete the current contents of /etc/update-motd.d/. Continue?" -c "update_motd"

