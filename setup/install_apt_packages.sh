#!/bin/bash

THISDIR="$(realpath $(dirname $0))"


LISTS_DIR=""

INSTALL_CLI=1
INSTALL_GUI=0

APT_PACKAGE_ARRAY=()


cat "$THISDIR/lists/apt_packages.cli" | mapfile APT_PACKAGE_ARRAY
mapfile -t APT_PACKAGE_ARRAY <<< $(cat $THISDIR/lists/apt_packages.cli)

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

