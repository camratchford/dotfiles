# Install and configure Discord

SCRATCH_DIR=$(mktemp -qd) && {
  wget -cO "$SCRATCH_DIR/discord-repo_1.2_all.deb" https://palfrey.github.io/discord-apt/discord-repo_1.2_all.deb
  sudo dpkg -i "$SCRATCH_DIR/discord-repo_1.2_all.deb"
}
rm -rf "$SCRATCH_DIR"

sudo apt-get update && sudo apt-get install -y discord

DISCORD_SETTINGS="$HOME/.config/discord/settings.json"
mkdir -p "$(dirname "$DISCORD_SETTINGS")"
if [ ! -f "$DISCORD_SETTINGS" ]; then
  echo "{}" > "$DISCORD_SETTINGS"
fi

jq '. + {"SKIP_HOST_UPDATE": true}' "$DISCORD_SETTINGS" > /tmp/discord.json && mv /tmp/discord.json "$DISCORD_SETTINGS"
