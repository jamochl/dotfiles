#!/bin/sh
autorandr -c
[[ -f ~/.Xresources  ]] && xrdb -merge ~/.Xresources &
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap &
[[ -f ~/.config/dwm/sxhkdrc ]] && sxhkd -c ~/.config/dwm/sxhkdrc &
[[ -f ~/.config/wallpaper ]] && xwallpaper --zoom ~/.config/wallpaper &

picom --backend glx --vsync &
dunst &
xset s 900 &
xset s noblank &
xset -dpms &
xss-lock -- slock &
redshift &
udiskie -A &
nm-applet &

while true ; do 
    ~/.local/scripts/bar_script.sh; sleep 5;
done &

while true; do
    dwm || pkill startdwm.sh
done
