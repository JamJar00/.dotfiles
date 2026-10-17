if command -v tea 2>&1; then
  tea install
else
  # Neovim
  curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
  sudo rm -rf /opt/nvim
  sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
  rm nvim-linux-x86_64.tar.gz

  echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> ~/.bashrc

  pip3 install pynvim
  nvim --headless +PlugInstall +qall

  # Pyright
  pip3 install pyright

  # Neovim config
  ln -s $(pwd)/nvim ~/.config/

  # Prompt
  curl -L https://github.com/JamJar00/prompt/releases/download/v1.1.0/prompt -o ~/.local/bin/prompt
  chmod +x ~/.local/bin/prompt

  # Fish
  sudo add-apt-repository -y ppa:fish-shell/release-3
  sudo apt-get install fish -y

  # Fish config
  mkdir ~/.config/fish
  ln -s $(pwd)/config.fish ~/.config/fish/config.fish

  # Change shell
  sudo chsh "$(id -un)" --shell "$(command -v fish)"
fi
