#!/bin/bash
set -e
if [ ! -z "$1" ]; then
    mass_date="$(date -d "$1 day" "+%Y%m%d")"
else
    mass_date="$(date "+%Y%m%d")"
fi
mass_url="https://universalis.com/australia/${mass_date}/mass.htm"

cache_file="/tmp/${mass_date}_mass"
if [ -f "$cache_file" ]; then
    LESSSECURE=1 less "$cache_file"
    exit
fi

html_data="$mass_url\n$(w3m -dump "$mass_url")"
linestart_pre="$(echo "$html_data" | awk "/Hours$/ { print NR }")"
linestart_pre2="$(("$linestart_pre" - 1))"
linestart="$(echo "$html_data" | awk "/Readings at Mass$/ { print NR }")"
endline="$(echo "$html_data" | awk "/^The readings on this page/ { print NR }")"
endline2="$(("$endline" - 1))"
echo -e "$html_data" | sed -n "1,${linestart_pre2}p;${linestart},${endline2}p" | \
  sed "$linestart,\$s/^━/\\n&/g" | \
  tee "$cache_file" | \
  LESSSECURE=1 less
exit 0
