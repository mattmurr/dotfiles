alias ls='lsd'
alias ll='ls -l'
alias curl='curlie'

export EDITOR="nvim"

export ZSH_TMUX_AUTOSTART=true
export VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
export VI_MODE_SET_CURSOR=true

export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore --color=always"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore --color=always"
export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border --ansi"
export FZF_CTRL_T_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --style=numbers --color=always --line-range :500 {}'"

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
  zgenom ohmyzsh plugins/pyenv

  zgenom ohmyzsh themes/cloud

  zgenom load ajeetdsouza/zoxide
  zgenom load wfxr/forgit

  # generate the init script from plugins above
  zgenom save

  zgenom compile "$HOME/.zshrc"
fi

eval "$(direnv hook zsh)"
