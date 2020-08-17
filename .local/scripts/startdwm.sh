#!/bin/sh
xrandr --output eDP1 --auto --output HDMI2 --mode 1920x1080 --rate 75 --above eDP1
[ -f ~/.Xresources  ] && xrdb -merge ~/.Xresources &
[ -f ~/.Xmodmap ] && xmodmap ~/.Xmodmap &
[ -f ~/.config/dwm/sxhkdrc ] && sxhkd -c ~/.config/dwm/sxhkdrc &
[ -f ~/.config/wallpaper ] && xwallpaper --zoom ~/.config/wallpaper &
picom &
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
    dwm || pkill startdwm.sh
done
