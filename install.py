#!/usr/bin/env python3
import envbot
import envbot.apt
import envbot.brew
import envbot.defaults
import envbot.pip
import envbot.scoop
import envbot.winget


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
    envbot.brew.install("terraform-ls")
    envbot.brew.install("watch")

    envbot.brew.install("iterm2", True)
    envbot.brew.install("karabiner-elements", True)
    envbot.brew.install("wacom-tablet", True)
    envbot.brew.install("caffeine", True)
    envbot.brew.install("font-hack-nerd-font", True) # Terminal font required for NvimTree icons
    envbot.brew.install("pritunl", True)
    envbot.brew.install("openvpn-connect", True)

    # Specify the preferences directory
    envbot.defaults.write("com.googlecode.iterm2.plist", "PrefsCustomFolder", envbot.cwd + "/iterm2")
    # Tell iTerm2 to use the custom preferences in the directory
    envbot.defaults.write("com.googlecode.iterm2.plist", "LoadPrefsFromCustomFolder", True)
else:
    envbot.shell("command -v mcfly &> /dev/null || curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to ~/.bin")

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

    # Terminal Font
    envbot.scoop.add_bucket("nerd-fonts")
    envbot.scoop.install("CascadiaCode-NF-Mono")

    # Windows store apps
    envbot.winget.install("9WZDNCRFJJ3T") # Huetro for Hue

    envbot.copy("./windows-terminal.json", "/mnt/c/Users/jamie/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json", overwrite=True)

envbot.chsh("fish")

envbot.pip.install("pynvim")
envbot.shell("nvim --headless +PlugInstall +qall")

envbot.pip.install("pyright")

envbot.exit()
