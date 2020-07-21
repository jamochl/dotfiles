# James' Zsh config - Requires oh-my-zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
source ~/.zprofile
source ~/.bash_aliases
# Remove duplicates from the path
typeset -U PATH path

# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/.zshhistfile
HISTSIZE=2000
SAVEHIST=2000

# to know which specific one was loaded, run: echo $RANDOM_THEME
ZSH_THEME="gallois"

export UPDATE_ZSH_DAYS=10
COMPLETION_WAITING_DOTS="true"

# Does git plugin track untracked files
DISABLE_UNTRACKED_FILES_DIRTY="true"

# For oh-my-zsh plugins
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
HIST_STAMPS="dd.mm.yyyy"

# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
plugins=(git)

# Sets zsh env variables, plugins etc
source $ZSH/oh-my-zsh.sh

# vi mode
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # added by the fzf installer
if [ -e /home/jameschlim/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jameschlim/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Do on startup
lent-reminder.sh
todo.sh
