#!/usr/bin/env bash

mkdir -p ~/.config/
ln -s $(pwd)/nvim ~/.config/ || true

ln -s $(pwd)/vimrc ~/.vimrc || true

mkdir -p /workspace/.vim ~/.vim/
ln -s /workspace/.vim ~/.vim/ || true

mkdir -p /workspace/.nvim ~/.local/share
ln -s /workspace/.nvim ~/.local/share/nvim || true

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz

sudo ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

pip install pynvim

sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
sudo ln -s /opt/kubectx/kubectx /usr/local/bin/kubectx
sudo ln -s /opt/kubectx/kubens /usr/local/bin/kubens

brew install terraform-ls

# TODO prompt needs GLIBC 2.39, but that's not available
# sudo curl -L https://github.com/JamJar00/prompt/releases/download/v1.0.1/prompt -o /usr/local/bin/prompt
# sudo chmod +x /usr/local/bin/prompt

echo "export EDITOR=nvim" >> ~/.bashrc
echo "export GIT_EDITOR=nvim" >> ~/.bashrc
# echo "export PS1='\$(prompt --exit-code \$?)'" >> ~/.bashrc

echo
echo "Run:"
echo "  source ~/.bashrc"
