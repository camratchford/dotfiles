#!/bin/bash

BACKUPS_DIR="$HOME/.local/share/backups/"
run-backups "$BACKUPS_DIR/paths" "$BACKUPS_DIR/rsyncignore"
