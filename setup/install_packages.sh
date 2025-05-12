#!/bin/bash -i

THISDIR="$(realpath $(dirname $0))"


LISTS_DIR="$THISDIR/lists"
PACKAGE_ARRAY=()

function set-package-list {
  local package_type="${1?"Missing package type"}"
  PACKAGE_ARRAY=()
  mapfile -t PACKAGE_ARRAY <<< $(cat $LISTS_DIR/${package_type}_packages.cli)

  if [ -n "$DISPLAY" ]; then
    mapfile -t -O ${#APT_PACKAGE_ARRAY[@]} PACKAGE_ARRAY <<< $(cat $LISTS_DIR/${package_type}_packages.gui)
  fi
}

function install-package-list {
  local package_type="${1?"Missing package type"}"
  for package_index in $(seq 0 ${#PACKAGE_ARRAY}); do
    if [ -n "${PACKAGE_ARRAY[$package_index]}" ]; then
      ${package_type} install ${PACKAGE_ARRAY[$package_index]}
    fi
  done
}

for package_type in apt snap; do
  set-package-list $package_type
  install-package-list $package_type
done

