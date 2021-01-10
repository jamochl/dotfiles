#!/bin/bash
set -e
if [ ! -z "$1" ]; then
    mass_date="$(date -d "$1 day" "+%Y%m%d")"
else
    mass_date="$(date "+%Y%m%d")"
fi

cache_file="/tmp/${mass_date}_mass"
if [ -f "$cache_file" ]; then
    LESSSECURE=1 less "$cache_file"
    exit
fi

html_data="$(w3m -dump "https://universalis.com/australia/${mass_date}/mass.htm")"
linestart_pre="$(echo "$html_data" | grep -n "Hours$")"
linestart_pre2="${linestart_pre%%:*}"
linestart_pre3="$(("$linestart_pre2" - 1))"
linestart="$(echo "$html_data" | grep -n "Readings at Mass$")"
linestart2="${linestart%%:*}"
endline="$(echo "$html_data" | grep -n "^The readings on this page")"
endline2="${endline%%:*}"
endline3="$(("$endline2" - 1))"
echo "$html_data" | sed -n "1,${linestart_pre3}p;${linestart2},${endline3}p" | sed \
    '6,$s/━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━/\n&/g' \
| tee "$cache_file" | LESSSECURE=1 less
exit 0
