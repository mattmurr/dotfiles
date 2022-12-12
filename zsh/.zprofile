eval "$(/opt/homebrew/bin/brew shellenv)"

export ZK_NOTEBOOK_DIR="$HOME/Documents/notes"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

. "$HOME/.sdkman/bin/sdkman-init.sh"
