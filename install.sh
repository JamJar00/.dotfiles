#!/usr/bin/env bash

ln -s ~/.config/nvim/init.vim vimrc || true

if [[ $(uname) == "Linux" ]]; then
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz

  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc
fi

pip install pynvim

echo 'export EDITOR="nvim"' >> ~/.bashrc
echo 'export GIT_EDITOR="nvim"' >> ~/.bashrc

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
