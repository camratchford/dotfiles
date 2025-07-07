#!/bin/bash -i

THISDIR="$(realpath $(dirname $0))"

LISTS_DIR="$THISDIR/lists"
PACKAGE_ARRAY=()

CLI_PACKAGES=0
GUI_PACKAGES=0
LIST_PACKAGES=0

print_help() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --cli     Install CLI packages only"
  echo "  --gui     Install GUI packages only"
  echo "  --all     Install both CLI and GUI packages"
  echo "  --list    List all packages to be installed (requiring one of --cli, --gui, --all)"
  echo ""
  echo "Example:"
  echo "  $0 --cli"
  echo "  $0 --gui"
  echo "  $0 --all"
  echo "  $0 --all --list"
  exit 1
}

# Show help if no arguments are provided
if [[ $# -eq 0 ]]; then
  print_help
fi

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cli)
      CLI_PACKAGES=1
      shift
      ;;
    --gui)
      GUI_PACKAGES=1
      shift
      ;;
    --all)
      CLI_PACKAGES=1
      GUI_PACKAGES=1
      shift
      ;;
    --list)
      LIST_PACKAGES=1
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      # Unknown positional argument
      echo "Unexpected argument: $1"
      exit 1
      ;;
  esac
done

function set-package-list {
  local package_type="${1?"Missing package type"}"
  PACKAGE_ARRAY=()
  if [[ "$CLI_PACKAGES" -eq 1 ]]; then
     mapfile -t PACKAGE_ARRAY <<< $(cat $LISTS_DIR/${package_type}_packages.cli)
  fi
  if [[ "$GUI_PACKAGES" -eq 1 ]]; then
    if [ -z "$DISPLAY" ]; then
      echo "DISPLAY env var is missing. Are you sure you wanted to install gui packages?"
      return 1
    fi
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
  if [[ "$LIST_PACKAGES" -eq 1 ]]; then
    echo -e "$package_type packages to be installed:"
    for package_index in $(seq 0 ${#PACKAGE_ARRAY}); do
      if [ -n "${PACKAGE_ARRAY[$package_index]}" ]; then
        echo "  ${PACKAGE_ARRAY[$package_index]}"
      fi
    done

  else
    install-package-list $package_type
  fi
done

