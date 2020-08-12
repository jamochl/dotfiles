#!/bin/sh

cd /sys/class/backlight/*/
max_backlight=$(cat ./max_brightness)
min_backlight=$(($max_backlight / 100))
current_backlight=$(cat ./brightness)
#echo "max: $max_backlight"
#echo "min: $min_backlight"
#echo "current: $current_backlight"

if [ $# = 0 ]; then
    echo 'Argument up or down'
    exit 0
fi

if [ -z $2 ]; then
    value=5
else
    value=$2
fi

case "$1" in
    up)
        backlight_change=$value
        ;;
    down)
        backlight_change=$(($value * -1))
        ;;
    *)
        backlight_change=0
        ;;
esac

new_backlight=$(($current_backlight + ($max_backlight * $backlight_change) / 100))

if [ $new_backlight -gt $max_backlight ]; then
    backlight=$max_backlight
elif [ $new_backlight -lt $min_backlight ]; then
    backlight=$min_backlight
else
    backlight=$new_backlight
fi

echo $backlight > brightness || echo 5000 > brightness
