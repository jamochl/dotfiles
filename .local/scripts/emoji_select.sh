#!/bin/sh
rofi -font 'FiraCode Nerd Font 12' -dmenu < $HOME/.local/scripts/emoji.txt | awk '{ print $1 }' | tr -d '\n' | xclip -sel clip
