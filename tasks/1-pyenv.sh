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

pyenv install 3.14 3.12 3.11
pyenv global 3.14
