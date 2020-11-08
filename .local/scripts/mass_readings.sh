#!/bin/bash
set -e
clean_up() {
    rm $TEMP_FILE $TEMP_FILE2
}
trap clean_up EXIT
TEMP_FILE="/tmp/tmp.MassReadingInput"
TEMP_FILE2="/tmp/tmp.MassReadingOutput"
if [ ! -z $1 ]; then
    mass_date="$(date -d "$1 day" "+%Y%m%d")"
else
    mass_date="$(date "+%Y%m%d")"
fi
w3m -dump "https://universalis.com/australia/${mass_date}/mass.htm" > "$TEMP_FILE"
linestart_pre="$(grep -n "Hours$" "$TEMP_FILE")"
linestart_pre="${linestart_pre%%:*}"
linestart_pre="$(($linestart_pre - 1))"
linestart="$(grep -n "Readings at Mass$" "$TEMP_FILE")"
linestart="${linestart%%:*}"
endline="$(grep -n "The readings on this page" "$TEMP_FILE")"
endline="${endline%%:*}"
endline="$(( $endline - 1 ))"
sed -n "1,${linestart_pre}p;${linestart},${endline}p" "$TEMP_FILE" > "$TEMP_FILE2"
sed -i \
    '6,$s/━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━/\n&/g' \
    "$TEMP_FILE2"
LESSSECURE=1 less "$TEMP_FILE2"
exit 0
