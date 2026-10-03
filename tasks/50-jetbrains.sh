# Install JetBrains toolbox

if which kwriteconfig5 &> /dev/null ; then
  kwriteconfig5 --file kglobalshortcutsrc --group kwin --key "Switch to TTY 2" "none,Ctrl+Alt+F2,Switch to TTY 2"
  if pgrep -x kwin_wayland > /dev/null; then
    qdbus org.kde.KWin /KWin reconfigure
  fi
fi

if [[ -f ~/.local/share/JetBrains/Toolbox/bin/jetbrains-toolbox ]]; then
  echo "JetBrains Toolbox already installed, skipping." >&2
  return 0
fi

SCRATCH_DIR=$(mktemp -qd) && {
  wget -cO "$SCRATCH_DIR/toolbox.tar.gz" "https://data.services.jetbrains.com/products/download?platform=linux&code=TBA"
  tar -C "$SCRATCH_DIR" -xf "$SCRATCH_DIR/toolbox.tar.gz"
  bash -c "$SCRATCH_DIR/*/jetbrains-toolbox"
}
rm -rf "$SCRATCH_DIR"
