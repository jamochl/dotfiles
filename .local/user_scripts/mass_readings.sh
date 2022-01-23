#!/bin/bash
set -e
if [ ! -z "$1" ]; then
    mass_date="$(date -d "$1 day" "+%Y%m%d")"
else
    mass_date="$(date "+%Y%m%d")"
fi
mass_url="https://universalis.com/australia/${mass_date}/mass.htm"

max_width=80
term_width=$(tput cols)
width=0

if [[ $term_width -ge $max_width ]]; then
  width=$max_width
else
  width=$(($term_width - 2))
fi

num_spaces="$((($term_width - $width) / 2))"
insert_string=$(python3 -c "print (' ' * $num_spaces)")

cache_file="/tmp/${mass_date}_mass.html"
if [[ ! -f "$cache_file" ]]; then
   curl --silent $mass_url -o $cache_file
fi

html_data="$mass_url\n$(w3m -cols $width -dump "$cache_file")"
linestart_pre="$(echo "$html_data" | awk "/Hours$/ { print NR }")"
linestart_pre2="$(("$linestart_pre" - 1))"
linestart="$(echo "$html_data" | awk "/Readings at Mass$/ { print NR }")"
endline="$(echo "$html_data" | awk "/^The readings on this page/ { print NR }")"
endline2="$(("$endline" - 1))"
echo -e "$html_data" | sed -n "1,${linestart_pre2}p;${linestart},${endline2}p" | \
  sed "$linestart,\$s/^━/\\n&/g" | \
  sed "s/^/$insert_string/g" | \
  LESSSECURE=1 less
exit 0
