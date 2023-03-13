export ZSH_TMUX_AUTOSTART=true
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true

source "$HOME/.zgenom/zgenom.zsh"

zgenom autoupdate

if ! zgenom saved; then

  # specify plugins here
  zgenom ohmyzsh

  zgenom ohmyzsh plugins/git
  zgenom ohmyzsh plugins/direnv
  zgenom ohmyzsh plugins/tmux
  zgenom ohmyzsh plugins/vi-mode
  zgenom ohmyzsh plugins/fzf
  zgenom ohmyzsh plugins/jenv
  zgenom ohmyzsh plugins/nvm
  zgenom ohmyzsh plugins/pyenv

  zgenom ohmyzsh themes/robbyrussell

  # generate the init script from plugins above
  zgenom save

  zgenom compile "$HOME/.zshrc"
fi

alias ls='lsd'
alias ll='ls -l'
alias lt='ls --tree'

alias curl='curlie'

export EDITOR="nvim"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
alias cat="bat"

export ZK_NOTEBOOK_DIR="$HOME/Sync/notes"

export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore_global --color=always"
export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border --ansi"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"

eval "$(direnv hook zsh)"
