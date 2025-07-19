#!/bin/bash

function run-backups {
  set -euo pipefail

  dry_run=false

  while [[ $# -gt 0 ]]; do
      case "$1" in
          --dry-run)
              dry_run=true
              shift
              ;;
          *)
              break
              ;;
      esac
  done

  if [[ $# -ne 2 ]]; then
      echo "Usage: $0 [--dry-run] paths.txt excludes.txt"
      exit 1
  fi

  default_paths_file="$BACKUPS_DEFAULT_PATHFILE"
  default_excludes_file="$BACKUPS_DEFAULT_EXCLUDEFILE"

  paths_file="${1:-$default_paths_file}"
  excludes_file="${2:-$default_excludes_file}"

  if [[ ! -f "$paths_file" ]]; then
      echo "Error: paths file not found: $paths_file"
      exit 1
  fi
  if [[ ! -f "$excludes_file" ]]; then
      echo "Error: excludes file not found: $excludes_file"
      exit 1
  fi

  while IFS=$'\t ' read -r src dest; do
      [[ -z "$src" || -z "$dest" || "$src" =~ ^# ]] && continue

      if [[ ! -d "$src" ]]; then
          echo "Warning: Source directory not found: $src"
          continue
      fi

      rsync_opts=(-avh --delete)

      $dry_run && rsync_opts+=(--dry-run)

      if [[ -f "$src/.gitignore" ]]; then
          rsync_opts+=(--filter=": .gitignore")
      else
          rsync_opts+=(--exclude-from="$excludes_file")
      fi

      echo -e "\nSyncing: $src -> $dest"
      rsync "${rsync_opts[@]}" "$src" "$dest"

  done < "$paths_file"

}
