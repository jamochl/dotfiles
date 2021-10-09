#!/bin/bash

dotfiles() {
    /usr/bin/git --git-dir=$HOME/.dotfiles --work-tree=$HOME $@
}

cd

menu="dmenu"

selected_script="$(dotfiles ls-files | \
     $menu)"

echo $selected_script

if [[ ! -z $selected_script ]]; then
    alacritty -e vim "$HOME/$selected_script"
fi
