export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"

ZSH_TMUX_AUTOSTART=true
VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true

plugins=(
  git
  direnv
  tmux
  vi-mode
  fzf
  jenv
  nvm
  pyenv
)

source $ZSH/oh-my-zsh.sh

alias ls='lsd'
alias ll='ls -l'
alias lt='ls --tree'

alias curl='curlie'

export EDITOR="nvim"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias cat="bat"

export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border --ansi"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"

export BAT_THEME="gruvbox-dark"

eval "$(direnv hook zsh)"
