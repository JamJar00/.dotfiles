#!/usr/bin/env bash

mkdir -p ~/.config/nvim
ln -s $(pwd)/vimrc ~/.config/nvim/init.vim || true

mkdir -p /workspace/.vim
ln -s /workspace/.vim ~/.vim || true

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc

pip install pynvim

echo 'export EDITOR="nvim"' >> ~/.bashrc
echo 'export GIT_EDITOR="nvim"' >> ~/.bashrc

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

/opt/nvim-linux-x86_64/bin/nvim --headless +PlugInstall +COQdeps +TSUpdate +qall
