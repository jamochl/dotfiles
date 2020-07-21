#!/bin/sh
cap=$(cat /sys/class/power_supply/BAT0/capacity)
status=$(cat /sys/class/power_supply/BAT0/status)
if [ $status = 'Charging' ]; then
    prefix='+'
else
    prefix=
fi
echo "${prefix}${cap}%"
