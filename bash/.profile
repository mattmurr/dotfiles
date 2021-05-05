# vi: ft=sh

# Always source bashrc
[[ -f ~/.bashrc ]] && . ~/.bashrc

# npm global dir in home.
export npm_config_prefix=~/.node_modules
PATH=$PATH:~/.node_modules/bin

# Android
export ANDROID_HOME=$(brew --prefix)/opt/android-sdk
