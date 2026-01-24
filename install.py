#!/usr/bin/env python3
import argparse
import os
import stat

import envbot
import envbot.util
import envbot.lowlevel.defaults
import envbot.lowlevel.git
import envbot.packs.terraform
import envbot.packs.node


# TODO Things that didn't install to Fluffles (Linux)
# - rustup
# - pip (needed a sudo apt install python3-pip as python is a managed environment)
# - poetry (needed a sudo apt install python3-poetry)
# - pynvim (needed a pipx install pynvim as not available in apt)
# - Nerdfonts

parser = argparse.ArgumentParser()
parser.add_argument("--with-dotnet", action="store_true")
parser.add_argument("--with-wacom", action="store_true")

args = envbot.init_from_parser(parser)

@envbot.step("Prompt install")
def install_prompt():
    if envbot.util.is_command_installed("prompt"):
        raise envbot.StepSkipped()

    envbot.lowlevel.git.git_clone("git@github.com:JamJar00/prompt.git", "~/Projects/prompt")
    envbot.shell("cd ~/Projects/prompt && cargo build")
    envbot.ensure_file_contains_text("~/.config/fish/config.fish.local", "fish_add_path ~/Projects/prompt/target/debug")


@envbot.step(".NET tool install", "{0}")
def install_dotnet_tool(name):
    if envbot.util.is_command_installed(name):
        raise envbot.StepSkipped()

    envbot.shell("dotnet tool install --global " + name)


@envbot.step("Install Rust Component", "{0}")
def install_rust_component(name):
    if envbot.util.is_command_installed(name):
        raise envbot.StepSkipped()

    envbot.shell("rustup component add " + name)


@envbot.step("Install NerdFont Manually")
def install_nerdfont_manually():
    envbot.shell("curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/CascadiaMono.zip -o CascadiaMono.zip")
    envbot.shell("unzip CascadiaMono.zip *.ttf")
    envbot.shell("mkdir -p ~/.fonts")
    envbot.shell("mv *.ttf ~/.fonts")
    envbot.shell("fc-cache -fv")
    envbot.shell("rm CascadiaMono.zip")

#
# Generic stuff
#
envbot.symlink("bashrc", "~/.bashrc")
envbot.symlink("gitconfig", "~/.gitconfig")
envbot.symlink("vimrc", "~/.vimrc")
envbot.symlink("nvim", "~/.config/nvim")
envbot.symlink("config.fish", "~/.config/fish/config.fish")

if envbot.platform == "Darwin":
    envbot.symlink("karabiner", "~/.config/karabiner")
    envbot.install("bash", "bash-completion@2", "caffeine", "docker", "fish", "font-hack-nerd-font", "gnupg", "iterm2", "jq", "karabiner-elements", "neovim", "ripgrep", "watch")

    if args.with_wacom:
        envbot.install("wacom-tablet")

    # Specify the preferences directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "PrefsCustomFolder", envbot.cwd + "/iterm2")
    # Tell iTerm2 to use the custom preferences in the directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "LoadPrefsFromCustomFolder", True)

if envbot.platform == "Windows":
    envbot.copy("./windows-terminal.json", "C:/Users/jamie/AppData/Local/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState/settings.json", overwrite=True)

    envbot.add_package_repositories("extras", "nerd-fonts", package_manager="scoop")
    envbot.install("win32yank", "CascadiaCode-NF-Mono", package_manager="scoop")

if envbot.platform == "Linux":
    envbot.add_package_repositories("ppa:fish-shell/release-3", "ppa:neovim-ppa/unstable")
    envbot.install("fish", "neovim")

    envbot.ensure_file_contains_text("/etc/profile.d/use-xinput2.sh", "export MOZ_USE_XINPUT2=1")

    install_nerdfont_manually()

envbot.install("pynvim", package_manager="pip")
envbot.shell("nvim --headless +PlugInstall +qall")

install_prompt()

envbot.chsh("fish")

#
# Machine specific steps
#
if envbot.hostname == "FXJXWHJ0W0.local":
    # dotnet-sdk omitted as the Homebrew install doesn't set it up right for csharp-ls
    envbot.install("helm", "kubectx", "kubernetes-cli", "minikube", "openvpn-connect", "pritunl",  "shellcheck", "terraform-ls", "tflint", "tfsec")

    envbot.packs.terraform.install_version("1.3.1")

    if args.with_dotnet:
        install_dotnet_tool("csharp-ls")

    install_rust_component("rust-analyzer")

    envbot.install_package_manager("pipx")
    envbot.install("poetry", "pyright", package_manager="pipx")

elif envbot.hostname == "FEATHERS" or envbot.hostname == "FLUFFLES":
    envbot.packs.node.install_version("22.12.0")

    envbot.add_package_repositories("ppa:fish-shell/release-3", "ppa:neovim-ppa/unstable")

    if args.with_dotnet:
        envbot.install("dotnet-sdk-8.0")

    if envbot.platform == "Windows":
        envbot.install("7zip", "coretemp", "cpu-z", "screentogif", "rclone", "yt-dlp", package_manager="scoop")

    @envbot.step("Install Docker")
    def install_docker():
        envbot.install("apt-transport-https", "ca-certificates" "curl", "software-properties-common")
        envbot.shell("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -")
        envbot.shell("sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"")
        envbot.install("docker-ce")
        envbot.shell("sudo gpasswd -a $USER docker")
        envbot.shell("sudo service docker start")

    # install_docker()

    if args.with_dotnet:
        install_dotnet_tool("csharp-ls")
    install_rust_component("rust-analyzer")

    envbot.install_package_manager("pipx")
    envbot.install("poetry", "pyright", package_manager="pipx")


envbot.exit()
