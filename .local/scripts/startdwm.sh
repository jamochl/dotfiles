#!/bin/sh
xrdb -merge ~/.Xresources &
sxhkd -c ~/.config/dwm/sxhkdrc &
picom &
xwallpaper --zoom ~/.config/wallpaper &
dunst &
xset s 900
xss-lock -- slock &

while true ; do
    nm-applet
done &

while true ; do 
    ~/.local/scripts/bar_script.sh; sleep 5;
done &

while true; do
    dwm || pkill startdwm.sh
done
