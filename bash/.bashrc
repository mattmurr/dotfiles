#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Attempt to attach to a tmux session or create a new one.
if type tmux &>/dev/null; then
  if [[ -z "$TMUX" ]]; then
    ID="$(tmux ls | grep -vm1 attached | cut -d: -f1)" # Try and get the id of a deattached session
    if [[ -z "$ID" ]]; then # If not available create a new session
      # Using exec here ensures that the terminal window is also closed when exiting tmux
      exec tmux new-session
    else
      exec tmux attach-session -t "$ID" # If available, attach to it
    fi
  fi
fi


# Enable vi mode, see ~/.inputrc
set -o vi

# Simply `cd` if a path is entered.
shopt -s autocd

# Shell prompt
git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1=' \W$(git_branch)\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

# direnv
if type direnv >&/dev/null; then
  eval "$(direnv hook bash)"

  show_virtual_env() {
    if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
      echo "($(basename $VIRTUAL_ENV))"
    fi
  }

  export -f show_virtual_env
  PS1='$(show_virtual_env)'$PS1
fi

export HISTCONTROL=ignoredups
export HISTSIZE=10000
export HISTFILESIZE=10000

export EDITOR=nvim
export VISUAL=nvim

# fzf
source $(brew --prefix)/share/fzf/{key-bindings,completion}.bash

export FZF_DEFAULT_COMMAND="fd -t f --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --hidden --follow --exclude '.git' --ignore-file $HOME/.gitignore"
export FZF_DEFAULT_OPTS="--height 100% --layout=reverse --border"

alias ls='ls --color'

# Get the weechat passphrase from pass - required to decrypt server passwords.
alias weechat='WEECHAT_PASSPHRASE=$(pass weechat) weechat'
