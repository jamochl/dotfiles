#!/bin/bash
# Script to cat and quickly edit list of reminders

STATIC_FILES="$HOME/.local/static_files"
if [[ $1 == "-e" ]]; then
    vim "$STATIC_FILES/reminders"
    exit 0
fi

[[ -f "$STATIC_FILES/reminders" ]] && cat $STATIC_FILES/reminders
