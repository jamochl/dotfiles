#!/bin/sh
xrdb -merge ~/.Xresources &
xrandr --noprimary --output eDP-1 --auto --output HDMI-1 --mode 1920x1080 --rate 75 --above eDP-1
sxhkd -c ~/.config/dwm/sxhkdrc &
compton --backend glx --vsync opengl-swc &
feh --bg-scale ~/Pictures/HILDA/Hilda_62.jpg &
dunst &
xset s 900 900
xss-lock -- slock &

while true ; do 
    ~/.local/scripts/bar_script.sh; sleep 5;
done &

while true; do
    dwm || exit
done
