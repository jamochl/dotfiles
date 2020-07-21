#!/bin/bash
##############################################################################
#                          markdown to pdf converter
#
#  Script to use Pandoc to export a Markdown file to desired PDF format
#
#  Change History
#  2020-03-03 Creation
#  [Insert New]
#
##############################################################################
##############################################################################
#
#  Core Maintainer:  James C. H. Lim
#  Email:            james.lim.ori@gmail.com
#
##############################################################################

# clean up script
##############################################################################
# Remove any temporary files
##############################################################################
clean_up() {
    rm -f "${ERROR_FILE[@]}"
    rm -f "${TEMP_FILES[@]}"
}
trap clean_up EXIT
trap 'clean_up; kill 0' SIGINT
ERROR_FILE+=("$(mktemp)") || exit 1

# Set script name for general file use
scriptname='mdtopdf'

print_help() {
    cat <<HEREDOC
Usage: $scriptname [Source]
Converts a markdown file to desired pdf format
(Accepts Piping)

    -h --help    Display help
    -v --verbose Display outputed pdfs
    -d --dry     Dry run output, implies verbose

END HELP
HEREDOC
}

make_pdf() {
    for file in "$@"; do
        dir="$(dirname "$file")/PDFS"
        base="$(basename "$file")"
        [ -d "$dir" ] || mkdir "$dir"
        output="$dir/${base%%.md}.pdf"
        # There is a bug with Pandoc, it command line is too long, it will
        # split a file name with a space in it. Therefore we use > rather than
        # -o "$output"
        pandoc "$file" -t pdf -V geometry:margin=2cm > "$output"
        echo "output: $output"
        if [[ -n $verbose ]]; then
            zathura "$output"
        fi
    done
}

dry_make_pdf() {
    for file in "$@"; do
        base="$(basename "$file")"
        dry_output="$(dirname "$file")/PDFS/${base%%.md}.pdf"
        echo "(DRY) output: $dry_output"

        TEMP_FILE="$(mktemp)" || exit 1
        TEMP_FILES+=("$TEMP_FILE")
        pandoc "$file" -t pdf -V geometry:margin=2cm > "$TEMP_FILE"
        zathura "$TEMP_FILE"
    done
}

main() {
    # Check to see if a pipe exists on stdin.
    if [ -p /dev/stdin ]; then
        while IFS= read line; do
            prearg+=("$line")
        done
    fi
    eval set -- "$@ ${prearg[@]}"

    # Parse all arguments using getopts
    args=$(getopt -o dhv -l dry,help,verbose --name "$scriptname" -- "$@") 2>"$ERROR_FILE"
    #echo "$args"; exit 0

    ################################################################################
    # If getopt outputs error to error variable, quit program displaying error
    ################################################################################
    [ $? -eq 0 ] || {
        cat "$ERROR_FILE"
        echo 'Please use --help for more information'
        exit 1
    }

    eval set -- "$args"

    while true; do
        case "$1" in
        -d | --dry)
            dry=1; shift; ;;
        -h | --help)
            print_help; exit 0; ;;
        -v | --verbose)
            verbose=1; shift; ;;
        --)
            shift; break; ;;
        *)
            echo "Programming error, this should not occur"; exit 1; ;;
        esac
    done

    if [[ $# -eq 0 ]]; then
        "Missing file arguments"
        print_help
        exit 1
    fi

    # Properly interpret ./ ~/ and ^\w file inputs
    for file in "$@"; do
        if [[ $(grep '^~/' <<< "$file") ]]; then
            FILE+=("$HOME/$file")
        elif [[ ! $(grep '^/' <<< "$file") ]]; then
            FILE+=("$(pwd)/${file#./}")
        fi
    done

    if [ -z $dry ]; then
        make_pdf "${FILE[@]}"
    else
        dry_make_pdf "${FILE[@]}"
    fi
}

main "$@"
