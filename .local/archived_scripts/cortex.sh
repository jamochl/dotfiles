#!/bin/sh

# Script to create, view and edit notes in my notes directory
# $1 greps category, $2 greps note. If more than one, return numbered list of
# results and when chosen, enter in vim

DIR="/home/james/notes"

if [ -z $2 ]; then
    echo "At least 2 args"
    exit 1;
fi

# $1 category, $2 notename
createNote() {
    mkdir -p "$1"
    vim "$1/$2.md"
}
# $1 notepath
editNote() {
    echo "$1"
    vim "$1"
}
# $1 list $2 max number
narrowChoice() {
    echo "$1" | cat -n 1>&2
    while :
    do
        read -p 'choose number[1]:> ' inputNumber
        inputNumber="${inputNumber:-1}"
        if [ "$inputNumber" -gt "$2" ] && [ "$inputNumber" -lt 1 ]
        then
            echo "invalid choice" 1>&2
        else
            echo $inputNumber
            break
        fi
    done
}

listCategory="$(find "$DIR" -type d -iname "*$1*")"
echo "listCat: $listCategory"
[ "$listCategory" != "" ] && numCategory="$(echo "$listCategory" | wc -l)" || numCategory=0
echo "numCat: $numCategory"
listNotes=""
if [ "$listCategory" = "" ]; then
    listNotes=""
else
    # TODO BUG, this runs regardless of whether listCat is empty...
    for category in "$listCategory"; do
        listNotes="${listNotes}$(find ${category:-$DIR} -type f)"
    done
fi
echo "listNotes: $listNotes"
filteredNotes="$(echo "$listNotes" | grep -i "$2")"
echo "filterNotes: $filteredNotes"
[ "$filteredNotes" != "" ] && numNotes="$(echo "$filteredNotes" | wc -l)" || numNotes=0
echo "numNotes: $numNotes"

# narrowChoice "$filteredNotes" "$numNotes"

if [ "$numNotes" -gt 1 ]; then
    # These "" are a pain :/
    numChoice="$(narrowChoice "$filteredNotes" "$numNotes")"
    echo 'editNote "$(echo "$filteredNotes" | sed --quiet ${numChoice}p)"'
    # editNote "$(echo "$filteredNotes" | sed --quiet ${numChoice}p)"
    editNote "$(echo "$filteredNotes" | sed --quiet ${numChoice}p)"
elif [ "$numNotes" -eq 1 ]; then
    editNote "$filteredNotes"
else
    echo 'Could not find note...'
    if [ "$numCategory" -gt 0 ]; then
        echo "Found categories ($listCategory)"
    fi
    read -p "Create new category instead? ($1) [N] :> " boolNew
    boolNew="${boolNew:-N}"
    if [ "$boolNew" != 'N' ]; then
        createNote "$DIR/$1" "$2"
    else
        if [ "$numCategory" -gt 1 ]; then
            numCategory="$(echo "$listCategory" | wc -l)"
            numChoice="$(narrowChoice "$listCategory" "$numCategory")"
            createNote "$(echo "$listCategory" | sed --quiet "${numChoice}p")" "$2"
        elif [ "$numCategory" -eq 1 ]; then
            createNote "$listCategory" "$2"
        else
            exit 0
        fi
    fi
fi
       
