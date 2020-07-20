# ALIASES

# General use
alias doit="sudo apt update && sudo apt upgrade -y"
alias mv="mv -v"
alias cp="cp -v"
alias vi='vim -u NONE'
alias open="xdg-open"
alias lf='lf -last-dir-path=$HOME/.cache/lfdir; cd $(cat $HOME/.cache/lfdir)'

# Conf Aliases
alias zshconf="$EDITOR ~/.zshrc"
alias aliasconf="$EDITOR ~/.bash_aliases"
alias zshso="source ~/.zshrc"
alias vimconf="$EDITOR ~/.vimrc"
alias nvimconf="$EDITOR ~/.config/nvim/init.vim"
alias tmuxconf="$EDITOR ~/.tmux.conf"
alias alaconf="$EDITOR ~/.config/alacritty/alacritty.yml"
alias bspconf="$EDITOR ~/.config/bspwm/bspwmrc"
alias sxhconf="$EDITOR ~/.config/sxhkd/sxhkdrc"
alias dsxhconf="$EDITOR ~/.config/dwm/sxhkdrc"
alias dunstconf="$EDITOR ~/.config/dunst/dunstrc"
alias gtkconf="$EDITOR ~/.config/gtk-3.0/settings.ini"
alias lfconf="$EDITOR ~/.config/lf/lfrc"

# Bookmarks
alias gtkcd="cd ~/.config/gtk-3.0/"
alias dwmcd="cd ~/projects/my_dwm/"
alias stcd="cd ~/projects/st/"
alias opencd="cd ~/notes/coding/opencat/"
alias lfcd="cd ~/.config/lf/"
alias haskcd="cd ~/projects/haskell/"

# Used to manage dotfiles
alias dotfiles="/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME"

# FUNCTIONS

# Web dev, setup a live server in local directory
live-server() {
    if [ $# -gt 0 ]; then
        browser-sync . -w --index=$1
    else
        browser-sync . -w
    fi
}

# Special terminal webapp functions
function cheat() { curl cheat.sh/$1 }
function weather() { curl wttr.in }
function covid() { curl -L covid19.trackercli.com/$1 }
function dict() { curl dict://dict.org/d:$1 }
