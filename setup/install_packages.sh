#!/bin/bash -i

THISDIR="$(realpath "$(dirname "$0")")"

LISTS_DIR="$THISDIR/lists"
PACKAGE_TYPES='apt snap'
PACKAGE_ARRAY=()

CLI_PACKAGES=0
GUI_PACKAGES=0
LIST_PACKAGES=0

function print-help {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --cli     Install CLI packages only"
  echo "  --gui     Install GUI packages only"
  echo "  --all     Install both CLI and GUI packages"
  echo "  --c-dev   Install packages for c/c++ development"
  echo "  --avr-dev Install packages for avr development"
  echo "  --list    List all packages to be installed (requiring one of --cli, --gui, --all)"
  echo ""
  echo "Example:"
  echo "  $0 --cli"
  echo "  $0 --gui"
  echo "  $0 --all"
  echo "  $0 --all --list"
  echo "  $0 --cli --c-dev"
  exit 1
}

# Show help if no arguments are provided
if [[ $# -eq 0 ]]; then
  print-help
fi

LIST_SUBDIR="common"
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
    --c-dev)
      LIST_SUBDIR="c-developer"
      shift
      ;;
    --avr-dev)
      LIST_SUBDIR="avr-developer"
      shift
      ;;
    --list)
      LIST_PACKAGES=1
      shift
      ;;
    --help|-h)
      print-help
      ;;
    -*)
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
  local PACKAGE_TYPE="${1?"Missing package type"}"
  PACKAGE_ARRAY=()
  if [[ "$CLI_PACKAGES" -eq 1 ]]; then
    CLI_LIST_FILE="$LISTS_DIR/$LIST_SUBDIR/${PACKAGE_TYPE}_packages.cli"
    if [ -f "$CLI_LIST_FILE" ]; then
      mapfile -t PACKAGE_ARRAY < <(grep -Ev '^\s*#|^\s*$' "$CLI_LIST_FILE")
    fi
  fi
  if [[ "$GUI_PACKAGES" -eq 1 ]]; then
    if [ -z "$DISPLAY" ]; then
      echo "DISPLAY env var is missing. Are you sure you wanted to install gui packages?"
      return 1
    fi
    GUI_LIST_FILE="$LISTS_DIR/$LIST_SUBDIR/${PACKAGE_TYPE}_packages.gui"
    if [ -f "$GUI_LIST_FILE" ]; then
      mapfile -t -O "${#APT_PACKAGE_ARRAY[@]}" PACKAGE_ARRAY < <(grep -Ev '^\s*#|^\s*$' "$GUI_LIST_FILE")
    fi
  fi
}

function install-package-list {
  local PACKAGE_TYPE="${1?"Missing package type"}"
  for package_index in $(seq 0 ${#PACKAGE_ARRAY[@]}); do
    PACKAGE_NAME="${PACKAGE_ARRAY[$package_index]}"
    INSTALL_ARGS=""
    if [ "${PACKAGE_TYPE}" == "apt" ]; then
      INSTALL_ARGS="${INSTALL_ARGS} -y -qq"
    fi
    if [ -n "$PACKAGE_NAME" ]; then
      # shellcheck disable=SC2086
      ${PACKAGE_TYPE} install ${INSTALL_ARGS} ${PACKAGE_NAME}
    fi
  done
}

for PACKAGE_TYPE in ${PACKAGE_TYPES}; do
  set-package-list "$PACKAGE_TYPE"
  if [[ "$LIST_PACKAGES" -eq 1 ]]; then
    echo -e "$PACKAGE_TYPE packages to be installed:"
    for PACKAGE_INDEX in $(seq 0 ${#PACKAGE_ARRAY[@]}); do
      if [ -n "${PACKAGE_ARRAY[$PACKAGE_INDEX]}" ]; then
        echo "  ${PACKAGE_ARRAY[$PACKAGE_INDEX]}"
      fi
    done
  else
    "$THISDIR/../bin/check-root" && echo "Installing packages" || exit 1
    install-package-list "$PACKAGE_TYPE"
  fi
done

