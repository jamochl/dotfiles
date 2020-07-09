#!/bin/sh
xrandr --output eDP-1 --primary --auto --output HDMI-1 --auto --above eDP-1
sxhkd -c /home/jameschlim/.config/dwm/sxhkdrc &
compton --backend glx --vsync opengl-swc &
feh --bg-scale ~/Pictures/HILDA/Hilda_62.jpg &
dunst &

while true ; do 
    time=$(date '+%d %b %Y - %I:%M %p')
    battery=$(sh $HOME/bin/system_query/battery_capacity.sh)
    xsetroot -name " $time $battery "; sleep 30; 
done &

exec dwm
