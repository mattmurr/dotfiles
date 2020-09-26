# vi: ft=sh

# Always source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Source bin and all subdirectories that are not hidden.
PATH=$PATH:$(find -L ~/bin/ -type d -name '[^\.]*' | tr '\n' ':' | sed 's/:$//')

# npm global dir in home.
export npm_config_prefix=~/.node_modules
PATH=$PATH:~/.node_modules/bin

# Haskell
PATH=$PATH:$HOME/.cabal/bin:$HOME/.ghcup/bin

# Go
PATH=$PATH:$HOME/go/bin

# Zig
PATH=$PATH:~/.zig

# Android
export ANDROID_SDK=/opt/android-sdk
PATH=$PATH:$ANDROID_HOME/platform
