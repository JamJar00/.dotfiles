if status is-interactive
  set -x EDITOR nvim
  set -x GPG_TTY (tty)

  fish_add_path ~/.local/bin
  fish_add_path ~/.bin
  fish_add_path ~/.cargo/bin
  fish_add_path /opt/homebrew/bin

  command -v mcfly &> /dev/null && mcfly init fish | source

  [ -s ~/.config/fish/config.fish.local ] && source ~/.config/fish/config.fish.local

  function fish_prompt
    prompt --exit-code $status
  end
end
