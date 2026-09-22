if status is-interactive
  set -x EDITOR nvim
  set -x GPG_TTY (tty)

  fish_add_path ~/.cargo/bin
  fish_add_path /opt/homebrew/bin

  # These need to come after cargo so they take precidence over the uninstalled shims cargo adds!
  fish_add_path ~/.bin
  fish_add_path ~/.local/bin

  command -v mcfly &> /dev/null && mcfly init fish | source

  set -x AWS_DEFAULT_REGION "eu-west-2"

  [ -s ~/.config/fish/config.fish.local ] && source ~/.config/fish/config.fish.local
  [ -s ~/.config/fish/config.local.fish ] && source ~/.config/fish/config.local.fish

  function fish_prompt
    set s $status

    if [ "$TERM_PROGRAM" = "iTerm.app" ]
      prompt --exit-code $s --iterm2
    else
      prompt --exit-code $s
    end
  end
end
