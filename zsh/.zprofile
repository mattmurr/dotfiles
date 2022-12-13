if [ -f "/opt/homebrew/bin/brew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

export ZK_NOTEBOOK_DIR="$HOME/Documents/notes"

eval "$(pyenv init --path)"

