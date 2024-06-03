#!/usr/bin/env python3
import argparse

import envbot
import envbot.lowlevel.defaults
import envbot.packs.terraform


parser = argparse.ArgumentParser()
parser.add_argument("--with-wacom", action="store_true")

args = envbot.init_from_parser(parser)


# Dotfiles
envbot.symlink("bashrc", "~/.bashrc")
envbot.symlink("gitconfig", "~/.gitconfig")
envbot.symlink("vimrc", "~/.vimrc")
envbot.symlink("vimrc", "~/.config/nvim/init.vim")
envbot.symlink("config.fish", "~/.config/fish/config.fish")

if envbot.platform == "Darwin":
    envbot.symlink("karabiner", "~/.config/karabiner")
else:
    envbot.copy("./windows-terminal.json", "/mnt/c/Users/jamie/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json", overwrite=True)


# Packages
envbot.install_package_manager()

if envbot.platform == "Darwin":
    envbot.install("bash", "bash-completion@2", "caffeine", "docker", "fish", "font-hack-nerd-font", "gnupg", "helm", "iterm2", "jq", "karabiner-elements", "kubectx", "kubernetes-cli", "mcfly", "minikube", "neovim",  "openvpn-connect", "pritunl", "ripgrep", "shellcheck", "terraform-ls", "tflint", "tfsec", "watch")

    if args.with_wacom:
        envbot.install("wacom-tablet")

    envbot.packs.terraform.install_version("1.3.1")
else:
    envbot.add_package_repositories("ppa:fish-shell/release-3", "ppa:neovim-ppa/unstable")
    envbot.add_package_repositories("extras", "nerd-fonts", package_manager="scoop")

    envbot.install("fish", "neovim")
    envbot.install("7zip", "powertoys", "screentogif", "win32yank", "CascadiaCode-NF-Mono", package_manager="scoop")

    envbot.shell("command -v mcfly &> /dev/null || curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to ~/.bin")


envbot.install("poetry", "pynvim", package_manager="pip")
envbot.install("pyright", package_manager="pipx")
envbot.shell("nvim --headless +PlugInstall +qall")


# Settings
if envbot.platform == "Darwin":
    # Specify the preferences directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "PrefsCustomFolder", envbot.cwd + "/iterm2")
    # Tell iTerm2 to use the custom preferences in the directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "LoadPrefsFromCustomFolder", True)


envbot.chsh("fish")


envbot.exit()
