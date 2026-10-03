# Install pyenv
curl https://pyenv.run | bash

sudo apt-get install -y \
  build-essential \
  libssl-dev \
  zlib1g-dev \
  libbz2-dev \
  libreadline-dev \
  libsqlite3-dev \
  libffi-dev \
  liblzma-dev

install_instructions=$(cat <<EOF
Now run:
exec bash
pyenv install 3.14 3.12 3.11
pyenv global 3.14
EOF
)
print "$install_instructions"
