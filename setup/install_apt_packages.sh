#!/bin/bash

THISDIR="$(realpath $(dirname $0))"


LISTS_DIR="$THISDIR/lists"
APT_PACKAGE_ARRAY=()

function get-package-list {
  local package_type="${1?"Missing package type"}"
  local suffix="${2?"Missing package suffix"}"
}

cat "$LISTS_DIR/apt_packages.cli" | mapfile APT_PACKAGE_ARRAY
mapfile -t APT_PACKAGE_ARRAY <<< $(cat $LISTS_DIR/apt_packages.cli)

if [ -n "$DISPLAY" ]; then
  mapfile -t -O ${#APT_PACKAGE_ARRAY[@]} APT_PACKAGE_ARRAY <<< $(cat $THISDIR/lists/apt_packages.gui)
fi

PROMPT="Install ${APT_PACKAGE_ARRAY[@]}? [y|n] "
read -p "$PROMPT" answer

case "$answer" in
  "y"|"Y")
    apt-get install -y ${APT_PACKAGE_ARRAY[@]}
    ;;
  *)
    echo "Aborting..."
    ;;
esac

