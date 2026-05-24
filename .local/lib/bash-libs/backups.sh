#!/bin/bash

function _run-backups {
  local extra_opts=()
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --*)
        extra_opts+=("$1")
        shift
        ;;
      *)
        break
        ;;
    esac
  done

  local paths_file excludes_file

  paths_file="${1:-"$HOME/.local/share/backups/rsyncignore"}"
  excludes_file="${2:-"$HOME/.local/share/backups/paths"}"

  if [ ! -e "$paths_file" ]; then
      echo "Error: paths file not found: $paths_file"
      return 1
  fi
  if [ ! -e "$excludes_file" ]; then
      echo "Error: excludes file not found: $excludes_file"
      return 1
  fi

  HOSTNAME=$(hostname)
  export HOSTNAME

  while IFS=$'\t ' read -r src dest; do
      # Continue if it has fewer than 2 items in a row or the row starts with #
      [[ -z "$src" || -z "$dest" || "$src" =~ ^# ]] && continue

      # Expand shell variables
      src=$(envsubst <<< "$src")
      dest=$(envsubst <<< "$dest")
      mkdir -p "$dest"

      if [[ ! -d $src ]]; then
          echo "Warning: Source directory not found: $src"
          continue
      fi

      rsync_opts=(-avh --delete --filter=": .rsyncignore" --exclude-from="$excludes_file")
      if [[ ${#extra_opts[@]} -gt 0 ]]; then
        rsync_opts+=("${extra_opts[@]}")
      fi

      echo -e "\nSyncing: $src -> $dest"
      rsync "${rsync_opts[@]}" "$src" "$dest"

  done < "$paths_file"
}

# Script to run rsync on $src\t$dest defined in a text file, ignoring patterns in a pattern file
# Usage: run-backups [--dry-run] [SRC_DEST_ROW_FILE RSYNC_IGNORE_FILE]
#   - default SRC_DEST_PATHS_FILE is $HOME/.local/share/backups/paths
#   - default RSYNC_IGNORE_FILE is $HOME/.local/share/backups/rsyncignore
function run-backups {
  case $- in
    *i*) _run-backups "$@" ;;
    *) _run-backups "$@" 2>&1 | /usr/bin/logger -t run-backups; exit "${PIPESTATUS[0]}" ;;
  esac
}

