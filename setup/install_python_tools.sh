#!/bin/bash

THISDIR="$(realpath "$(dirname "$0")")"
VENV_DIR="$(realpath "$THISDIR/../venv")"
PIP_PATH="$VENV_DIR/bin/pip"
BIN_DIR="$HOME/.local/bin"

python3 -m venv $VENV_DIR
$PIP_PATH install --no-input --no-cache-dir --exists-action w --upgrade pip setuptools
$PIP_PATH install --no-input --no-cache-dir --exists-action w -r "$THISDIR/requirements.txt"
LINK_BINS="pip_search"

for bin in $LINK_BINS; do
  BIN_REAL_PATH="$(realpath "$VENV_DIR/bin/$bin")"
  BIN_TARGET_PATH="$(realpath "$BIN_DIR/$bin")"
  if ! [ -f "$BIN_REAL_PATH" ]; then
    echo "$BIN_REAL_PATH does not exist"
    exit 1
  fi
  if [ -L "$BIN_TARGET_PATH" ] || [ -f "$BIN_TARGET_PATH" ]; then
    continue
  fi
  ln -s "$BIN_REAL_PATH" "$BIN_TARGET_PATH"
done

