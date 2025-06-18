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
if envbot.platform == "Darwin":
    # dotnet-sdk omitted as the Homebrew install doesn't set it up right for csharp-ls
    envbot.install("bash", "bash-completion@2", "caffeine", "docker", "fish", "font-hack-nerd-font", "gnupg", "helm", "iterm2", "jq", "karabiner-elements", "kubectx", "kubernetes-cli", "mcfly", "minikube", "neovim",  "openvpn-connect", "pritunl", "ripgrep", "rust-analyzer", "shellcheck", "terraform-ls", "tflint", "tfsec", "watch")

    if args.with_wacom:
        envbot.install("wacom-tablet")

    envbot.packs.terraform.install_version("1.3.1")
else:
    envbot.packs.node.install_version("22.12.0")

    envbot.add_package_repositories("ppa:fish-shell/release-3", "ppa:neovim-ppa/unstable")
    envbot.add_package_repositories("extras", "nerd-fonts", package_manager="scoop")

    envbot.install("dotnet-sdk-8.0", "fish", "neovim")
    envbot.install("7zip", "coretemp", "cpu-z", "screentogif", "rclone", "win32yank", "yt-dlp", "CascadiaCode-NF-Mono", package_manager="scoop")

    @envbot.step("Install Mcfly")
    def install_mcfly():
        if envbot.util.is_command_installed("mcfly"):
            raise envbot.StepSkipped()

        envbot.shell("curl -LSfs https://raw.githubusercontent.com/cantino/mcfly/master/ci/install.sh | sh -s -- --git cantino/mcfly --to ~/.bin")

    install_mcfly()

    @envbot.step("Install Rust Analyzer")
    def install_rust_analyzer():
        envbot.make_directories("~/.local/bin")
        envbot.shell("curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip -c - > ~/.local/bin/rust-analyzer")
        st = os.stat(os.path.expanduser("~/.local/bin"))
        envbot.chmod("~/.local/bin/rust-analyzer", st.st_mode | stat.S_IEXEC)

    install_rust_analyzer()

    @envbot.step("Install Docker")
    def install_docker():
        envbot.install("apt-transport-https", "ca-certificates" "curl", "software-properties-common")
        envbot.shell("curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -")
        envbot.shell("sudo add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"")
        envbot.install("docker-ce")
        envbot.shell("sudo gpasswd -a $USER docker")
        envbot.shell("sudo service docker start")

    install_docker()


@envbot.step(".NET tool install", "{0}")
def install_dotnet_tool(name):
    if envbot.util.is_command_installed(name):
        raise envbot.StepSkipped()

    envbot.shell("dotnet tool install --global " + name)

install_dotnet_tool("csharp-ls")

envbot.install_package_manager("pipx")
envbot.install("poetry", "pyright", package_manager="pipx")

envbot.install("pynvim", package_manager="pip")
envbot.shell("nvim --headless +PlugInstall +qall")

@envbot.step("Prompt install")
def install_prompt():
    if envbot.util.is_command_installed("prompt"):
        raise envbot.StepSkipped()

    envbot.lowlevel.git.git_clone("git@github.com:JamJar00/prompt.git", "~/Projects/prompt")
    envbot.shell("cd ~/Projects/prompt && cargo build")
    envbot.ensure_file_contains_text("~/.config/fish/config.fish.local", "fish_add_path ~/Projects/prompt/target/debug")

install_prompt()

# Settings
if envbot.platform == "Darwin":
    # Specify the preferences directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "PrefsCustomFolder", envbot.cwd + "/iterm2")
    # Tell iTerm2 to use the custom preferences in the directory
    envbot.lowlevel.defaults.write("com.googlecode.iterm2.plist", "LoadPrefsFromCustomFolder", True)


envbot.chsh("fish")


envbot.exit()
