#!/bin/sh

time="$(date '+%I:%M %p | %d %b %Y')"

battery_capacity="$(sh $HOME/.local/scripts/system_query/battery_capacity.sh)"
if [ ${battery_capacity%\%} -lt 20 ]; then
    battery_capacity="  !$battery_capacity"
elif [ ${battery_capacity%\%} -lt 50 ]; then
    battery_capacity="  $battery_capacity"
else
    battery_capacity="  $battery_capacity"
fi
battery="$battery_capacity"

pulse_status="$(pactl list sinks)"
volume=$(echo "$pulse_status" | awk '/^\s*Volume:/ {print $5}')
mute_status=$(echo "$pulse_status" | awk '/^\s*Mute:/ {print $2}')
if [ ${volume%\%} -eq 0 ]; then
    volume="🔈 ${volume}"
elif [ $mute_status = 'yes' ]; then
    volume="🔇 muted"
else
    volume="🔉 ${volume}"
fi

max_backlight=$(cat /sys/class/backlight/intel_backlight/max_brightness)
actual_backlight=$(cat /sys/class/backlight/intel_backlight/brightness)
backlight_percent=$(( ($actual_backlight * 100) / $max_backlight ))
backlight="☀ $backlight_percent%"

memory="💿 $(sh $HOME/.local/scripts/system_query/memory_used.sh)"

xsetroot -name " $memory | $volume | $backlight | $time | $battery "
