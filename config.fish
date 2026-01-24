if status is-interactive
  set -x EDITOR nvim
  set -x GPG_TTY (tty)

  fish_add_path ~/.cargo/bin
  fish_add_path /opt/homebrew/bin

  # These need to come after cargo so they take precidence over the uninstalled shims cargo adds!
  fish_add_path ~/.bin
  fish_add_path ~/.local/bin

  fish_add_path ~/Projects/prompt/target/debug

  command -v mcfly &> /dev/null && mcfly init fish | source

  [ -s ~/.config/fish/config.fish.local ] && source ~/.config/fish/config.fish.local
  [ -s ~/.config/fish/config.local.fish ] && source ~/.config/fish/config.local.fish

  function fish_prompt
    if [ "$TERM_PROGRAM" = "iTerm.app" ]
      prompt --exit-code $status --iterm2
    else
      prompt --exit-code $status
    end
  end

  function tea
    poetry -P ~/Projects/tea run tea $argv
  end
end
