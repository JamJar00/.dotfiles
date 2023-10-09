if status is-interactive
  function fish_prompt
    echo -n \n(set_color green)(prompt_pwd)

    # Git bit
    if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]
      echo -n " "(set_color brblue)(git branch --show-current)
    end

    # K8s bit
    if command -v kubectl &> /dev/null
      echo -n " "(set_color blue)(kubectl config current-context 2>/dev/null)" "(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    end

    # AWS bit
    if [ -n $AWS_PROFILE ]
      echo -n " "(set_color red)$AWS_PROFILE
    end

    if [ -n $AWS_REGION ]
      echo -n " "(set_color red)$AWS_REGION
    else if [ -n $AWS_DEFAULT_REGION ]
      echo -n " "(set_color red)$AWS_DEFAULT_REGION
    else if [ -n $AWS_PROFILE_REGION ]
      echo -n " "(set_color red)$AWS_DEFAULT_REGION
    end

    echo

    # A chevron shows last exit code
    if [ $status = 0 ]
      echo -n (set_color green)❯
    else
      echo -n (set_color red)❯
    end

    # B chevron shows unstaged changes
    if [ -d .git ]
      if [ git diff-index --quiet HEAD -- 2>/dev/null >/dev/null ]
        echo -n (set_color green)❯
      else
        echo -n (set_color yellow)❯
      end
    else
      echo -n (set_color normal)❯
    end

    # C chevron shows unpushed changes
    if [ -d .git ]
      if [ -z "$(git log @{u}.. 2>/dev/null)" ]
        echo -n (set_color green)❯
      else
        echo -n (set_color yellow)❯
      end
    else
      echo -n (set_color normal)❯
    end

    echo " "
  end
end

