if status is-interactive
  set -x EDITOR nvim
  set -x GPG_TTY (tty)

  fish_add_path ~/.cargo/bin
  fish_add_path /opt/homebrew/bin

  # These need to come after cargo so they take precidence over the uninstalled shims cargo adds!
  fish_add_path ~/.bin
  fish_add_path ~/.local/bin

  command -v mcfly &> /dev/null && mcfly init fish | source

  [ -s ~/.config/fish/config.fish.local ] && source ~/.config/fish/config.fish.local

  function fish_prompt
    prompt --exit-code $status
  end
end
