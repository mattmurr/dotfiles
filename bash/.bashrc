#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Attempt to attach to a tmux session or create a new one.
if [[ $DISPLAY ]]; then
  if [[ -z "$TMUX" ]] ;then
    ID="$( tmux ls | grep -vm1 attached | cut -d: -f1 )" # get the id of a deattached session
    if [[ -z "$ID" ]] ;then # if not available create a new one
        exec tmux new-session
    else
      # Update dbus and display then we can attach.
      for pane in $(tmux list-windows -t $ID); do
        tmux send -t $ID:$pane export DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" ENTER
        tmux send -t $ID:$pane export DISPLAY="$DISPLAY" ENTER
        tmux send -t $ID:$pane export SSH_AUTH_SOCK="$SSH_AUTH_SOCK" ENTER
        exec tmux attach-session -t "$ID"
      done
    fi
  fi
fi

# Vi mode, see ~/.inputrc
set -o vi

# FZF
source /usr/share/fzf/key-bindings.bash
export FZF_CTRL_R_OPTS='--sort --exact'

# Just cd if a path is entered.
shopt -s autocd

# Prompt PS1
git_branch() {
     git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

export PS1='[\u@\h \W$(git_branch)]\$ '
export PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/~}\007"'

export EDITOR=nvim
export VISUAL=nvim
export TERMINAL=alacritty

# Wayland
export MOZ_ENABLE_WAYLAND=1

alias ls='ls --color'

# Get the weechat passphrase from pass - required to decrypt server passwords.
alias weechat='WEECHAT_PASSPHRASE=$(pass weechat) weechat'

# Transmission-remote
alias tl='transmission-remote -l'
alias ta='transmission-remote -a'
