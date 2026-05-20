#!/bin/bash

if [[ $EUID -ne 0  ]]; then
  echo "This script must be run as root"
  exit 0
fi


THIS_DIR="$(dirname "$(realpath "$0")")"

LINES=$(tput lines)
HEIGHT=$(( LINES / 2  ))
COLUMNS=$(tput cols)
WIDTH=$(( COLUMNS / 2 ))

LIST_DIR="$THIS_DIR/software_packages"
SOFTWARE_PACKAGES=()
PACKAGE_LISTS=""
CHECKLIST_ITEMS=()

for list_file in $LIST_DIR/*.list; do
  name="$(basename "$list_file")"
  description="$(head -1 "$list_file")"
  checked="off"
  if [ "$name" == "required.list" ]; then
    checked="on"
  fi
  CHECKLIST_ITEMS+=("$name" "${description:2}" "$checked")
done

SELECTED_LISTS=$(whiptail --notags --title "Package Selection" \
  --checklist "Select which packages to install" \
  "$HEIGHT" "$WIDTH" "$CHECKLIST_ITEM_COUNT" \
  "${CHECKLIST_ITEMS[@]}" 3>&1 1>&2 2>&3
)

SELECTED_LISTS="$(echo $SELECTED_LISTS | tr -d '"')"

for package_list in $SELECTED_LISTS; do
  while IFS= read -r package; do
    [[ -z "$package" || "$package" =~ ^[[:space:]]*# ]] && continue
    package="${package#"${package%%[![:space:]]*}"}"
    package="${package%"${package##*[![:space:]]}"}"
    SOFTWARE_PACKAGES+=("$package")
  done < "${LIST_DIR}/$package_list"
done

if [[ ${#SOFTWARE_PACKAGES[@]} -gt 0 ]]; then
    apt update && apt install -y "${SOFTWARE_PACKAGES[@]}"
else
    echo "No packages to install"
fi
