#!/bin/sh

time="$(date '+%I:%M %p | %a %d/%m/%Y')"

battery_capacity="$(sh $HOME/.local/scripts/system_query/battery_capacity.sh)"
if [[ ${battery_capacity%\%} -lt 25 ]]; then
    battery_capacity="  !$battery_capacity"
elif [[ ${battery_capacity%\%} -lt 50 ]]; then
    battery_capacity="  $battery_capacity"
elif [[ ${battery_capacity%\%} -lt 75 ]]; then
    battery_capacity="  $battery_capacity"
else
    battery_capacity="  $battery_capacity"
fi
battery="$battery_capacity"

volume=$(pamixer --get-volume)
mute_status=$(pamixer --get-mute)
if [[ $mute_status = 'true' ]]; then
    volume=" muted"
elif [[ ${volume%\%} -eq 0 ]]; then
    volume=" ${volume}"
elif [[ ${volume%\%} -lt 20 ]]; then
    volume=" ${volume}%"
else
    volume=" ${volume}%"
fi

max_backlight=$(cat /sys/class/backlight/*/max_brightness)
actual_backlight=$(cat /sys/class/backlight/*/brightness)
backlight_percent=$(( ($actual_backlight * 100) / $max_backlight ))
backlight="☀ $backlight_percent%"

# memory="💿 $(sh $HOME/.local/scripts/system_query/memory_used.sh)"
# xsetroot -name " $memory | $volume | $backlight | $time | $battery "

xsetroot -name "$volume | $backlight | $time | $battery "
