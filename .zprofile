eval "$(/opt/homebrew/bin/brew shellenv)"

export LDFLAGS="-L/opt/homebrew/opt/llvm/lib/c++ -L/opt/homebrew/opt/llvm/lib -lunwind"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
export CC="/opt/homebrew/opt/llvm/bin/clang"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

export ZK_NOTEBOOK_DIR="$HOME/notes"

export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

