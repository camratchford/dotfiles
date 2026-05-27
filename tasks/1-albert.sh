# Install Albert

echo 'deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_26.04/ /' | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_26.04/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
sudo apt-get update
sudo apt-get install -y albert
