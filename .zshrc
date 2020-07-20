#. ~/bin/my_functions.sh
# Path to your oh-my-zsh installation.
export ZSH="/home/jameschlim/.oh-my-zsh"
source ~/.profile
source ~/.bash_aliases

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

source $ZSH/oh-my-zsh.sh

# vi mode
bindkey -v
export KEYTIMEOUT=1

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if [ -e /home/jameschlim/.nix-profile/etc/profile.d/nix.sh ]; then . /home/jameschlim/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer

# Do on startup
lent-reminder.sh
todo.sh
