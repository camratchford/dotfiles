#!/bin/bash
bash-libs
BACKUPS_DIR="$HOME/.local/share/backups/"
run-backups --background "$BACKUPS_DIR/paths" "$BACKUPS_DIR/rsyncignore"
