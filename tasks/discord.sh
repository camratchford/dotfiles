# Install and configure Discord
wget -o /tmp/discord-repo_1.2_all.deb https://palfrey.github.io/discord-apt/discord-repo_1.2_all.deb
sudo dpkg -i /tmp/discord-repo_1.2_all.deb
sudo apt-get update && sudo apt-get install -y discord

DISCORD_SETTINGS=~/.config/discord/settings.json
if [ ! -f "$DISCORD_SETTINGS" ]; then
  mkdir -p "$DISCORD_SETTINGS"
  echo "{}" > "$DISCORD_SETTINGS"
fi

jq '. + {"SKIP_HOST_UPDATE": true}' ~/.config/discord/settings.json > /tmp/discord.json && mv /tmp/discord.json ~/.config/discord/settings.json
