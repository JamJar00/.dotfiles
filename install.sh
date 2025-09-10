#!/usr/bin/env bash

mkdir -p ~/.config
ln -s $(pwd)/nvim ~/.config/ || true

ln -s $(pwd)/vimrc ~/.vimrc || true

mkdir -p /workspace/.vim
ln -s /workspace/.vim ~/.vim/ || true

mkdir -p /workspace/.nvim
ln -s /workspace/.nvim ~/.local/share/nvim/ || true

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

pip install pynvim

echo 'export EDITOR="nvim"' >> ~/.bashrc
echo 'export GIT_EDITOR="nvim"' >> ~/.bashrc

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens
