# vi: ft=sh

# Always source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Source bin and all subdirectories that are not hidden.
PATH=${PATH}:$(find ~/bin -type d -name '[^\.]*' | tr '\n' ':' | sed 's/:$//')

# Python binaries install here.
PATH=$PATH:~/.local/bin

# npm global dir in home.
export npm_config_prefix=~/.node_modules
PATH=$PATH:~/.node_modules/bin

# Haskell
PATH=$PATH:$HOME/.cabal/bin:$HOME/.ghcup/bin

# Zig
PATH=$PATH:~/.zig
