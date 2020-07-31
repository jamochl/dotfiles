#!/bin/sh
xrdb -merge ~/.Xresources &
xrandr --output eDP-1 --auto --output HDMI-1 --mode 1920x1080 --rate 75 --above eDP-1
sxhkd -c ~/.config/dwm/sxhkdrc &
picom &
xwallpaper --zoom ~/.config/wallpaper &
dunst &
xset s 900
xss-lock -- slock &

# while true ; do
#     nm-applet
# done &

while true ; do 
    ~/.local/scripts/bar_script.sh; sleep 5;
done &

while true; do
    # dwm || pkill startdwm.sh
    dwm || kill 0; exit;
done
