#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 100
fi

UPDATE_MOTD="/etc/update-motd.d"

# confirm overwrite
ansi --bold --white "This script will delete the current contents of /etc/update-motd.d/"
echo ""
ansi --bold --white "  Continue?"
ansi --white "y|n"
read PROMPT
if [[ $PROMPT == 'n' || $PROMPT == 'N' ]]; then
  exit
fi

# Delete existing
rm -rf "$UPDATE_MOTD/{*,.*}"

# Expand tar.gz
tar -xzvf update-motd.tar.gz -C /
