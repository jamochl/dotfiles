#!/bin/bash
clean_up() {
    rm $TEMP_FILE $TEMP_FILE2
}
trap clean_up EXIT
TEMP_FILE="/tmp/tmp.MassReadingInput"
TEMP_FILE2="/tmp/tmp.MassReadingOutput"
w3m -dump "https://universalis.com/australia/1100/mass.htm" > "$TEMP_FILE"
linestart="$(grep -n "Readings at Mass$" "$TEMP_FILE")"
linestart="${linestart%%:*}"
endline="$(grep -n "The readings on this page" "$TEMP_FILE")"
endline="${endline%%:*}"
endline="$(( $endline - 1 ))"
sed -n "${linestart},${endline}p" "$TEMP_FILE" > "$TEMP_FILE2"
sed -i \
    '6,$s/━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━/\n&/g' \
    "$TEMP_FILE2"
LESSSECURE=1 less "$TEMP_FILE2"
exit 0
