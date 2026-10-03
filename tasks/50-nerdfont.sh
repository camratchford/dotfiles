# Download and Install JetbrainsMono NerdFont

LOCAL_FONTS="$HOME/.local/share/fonts"
mkdir -p "$LOCAL_FONTS"
wget -O "$LOCAL_FONTS/JetBrainsMono.zip" https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
cd "$LOCAL_FONTS" && unzip -j "$LOCAL_FONTS/JetBrainsMono.zip" JetBrainsMonoNerdFont-Regular.ttf
rm "$LOCAL_FONTS/JetBrainsMono.zip"
fc-cache -vf
