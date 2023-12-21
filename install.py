#!/usr/bin/env python3

import envbot
import envbot.apt
import envbot.brew
import envbot.pip
import envbot.scoop

envbot.init()

envbot.symlink("bashrc", "~/.bashrc")
envbot.symlink("gitconfig", "~/.gitconfig")
envbot.symlink("vimrc", "~/.vimrc")
envbot.symlink("vimrc", "~/.config/nvim/init.vim")
envbot.symlink("config.fish", "~/.config/fish/config.fish")

if envbot.platform == "Darwin":
    envbot.symlink("karabiner", "~/.config/karabiner")

    envbot.brew.install("bash")
    envbot.brew.install("bash-completion@2")
    envbot.brew.install("docker")
    envbot.brew.install("gnupg")
    envbot.brew.install("helm")
    envbot.brew.install("jq")
    envbot.brew.install("kubectx")
    envbot.brew.install("kubernetes-cli")
    envbot.brew.install("mcfly")
    envbot.brew.install("minikube")
    envbot.brew.install("neovim")
    envbot.brew.install("ripgrep")
    envbot.brew.install("tfenv")
    envbot.brew.install("watch")

    envbot.brew.install("iterm2", True)
    envbot.brew.install("karabiner-elements", True)
    envbot.brew.install("wacom-tablet", True)
    envbot.brew.install("caffeine", True)
    envbot.brew.install("font-hack-nerd-font", True) # Terminal font required for NvimTree icons

else:
    envbot.shell("command -v mcfly &> /dev/null || curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to ~/.bin")

    envbot.copy("./windows-terminal.json", "/mnt/c/Users/jamie/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json")
    envbot.download("https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/CascadiaCode.zip", "CascadiaCode.zip") # TODO echo that a manual action needs to happen

    # Install Neovim
    envbot.apt.add_repository("ppa:neovim-ppa/unstable")
    envbot.apt.install("neovim")

    # Install fish
    envbot.apt.add_repository("ppa:fish-shell/release-3")
    envbot.apt.install("fish")

    envbot.scoop.add_bucket("extras")
    envbot.scoop.install("7zip")
    envbot.scoop.install("powertoys")
    envbot.scoop.install("screentogif")
    envbot.scoop.install("win32yank")
    # TODO Windows Terminal

envbot.shell("usermod -s $(which fish) $(whoami)")
# envbot.shell("chsh $(whoami) --shell $(which fish)")

envbot.pip.install("pynvim")
envbot.shell("nvim --headless +PlugInstall +qall")

envbot.exit()
