#!/bin/sh
xrandr --output eDP-1 --primary --auto --output HDMI-1 --auto --above eDP-1
sxhkd -c /home/jameschlim/.config/dwm/sxhkdrc &
compton --backend glx --vsync opengl-swc &
feh --bg-scale ~/Pictures/HILDA/Hilda_62.jpg &
dunst &

while true ; do 
    ~/bin/bar_script.sh; sleep 5;
done &

while true; do
    dwm
done
