#!/bin/bash
for project_dir in /projects/*/; do
  if [ "$(git -C "$project_dir" rev-parse --show-toplevel 2> /dev/null)/" != "$project_dir" ]; then
    MSG="Message from '$(basename $0)': \"Project '$project_dir' is not being tracked in Git\""
    # wall won't let me send myself a message without the banner unless my EUID is 0
    for pts in $(find /dev/pts -uid $UID); do
      echo $MSG > $pts
    done
  else
    continue
  fi
done
