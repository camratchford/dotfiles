#!/bin/bash

if [[ $EUID -eq 0  ]]; then
  echo "This script must not be run as root"
  exit 0
fi


THIS_DIR="$(dirname "$(realpath "$0")")"

LINES=$(tput lines)
HEIGHT=$(( LINES / 2  ))
COLUMNS=$(tput cols)
WIDTH=$(( COLUMNS / 2 ))

LIST_DIR="$THIS_DIR/tasks"
SOFTWARE_PACKAGES=()
CHECKLIST_ITEMS=()

for list_file in "$LIST_DIR"/*.sh; do
  name="$(basename "$list_file")"
  description="$(head -1 "$list_file")"
  checked="off"
  CHECKLIST_ITEMS+=("$name" "${description:2}" "$checked")
done

SELECTED_LISTS=$(whiptail --notags --title "Task Selection" \
  --checklist "Select which tasks to run" \
  "$HEIGHT" "$WIDTH" "$CHECKLIST_ITEM_COUNT" \
  "${CHECKLIST_ITEMS[@]}" 3>&1 1>&2 2>&3
)

SELECTED_LISTS="$(echo $SELECTED_LISTS | tr -d '"')"

echo "Running: sudo apt-get update"
sudo apt-get update &> /dev/null
echo "Running task(s)"
for task in $SELECTED_LISTS; do
  . "$LIST_DIR/$task"
done
