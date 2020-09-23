#!/bin/bash
#################################################################################
#                                 jlBackup
#
#  Script to backup key home folders
#
#  Change History
#  2020 ~ 11/02/2020    James Lim   Preliminary code testing, implementing
#                                   file reading, getopt.
#  11/02/2020 James Lim  Documentation and minor edits
#  [Insert New]
#
################################################################################

# Time script
SECONDS=0

# Set script name for general file use
scriptname='jl-Backup'

# clean up script
################################################################################
# Remove any temporary files
################################################################################
clean_up() {
    rm -f "$ERROR_FILE"
}
trap clean_up EXIT
trap 'clean_up; kill 0' SIGINT
ERROR_FILE+=("$(mktemp)") || exit 1

# User help
################################################################################
# Prints user guide
################################################################################
print_help() {
  echo \
  'Usage: jlbackup [OPTION]
This script is an incremental backup command based on Rsync, that will read
from the folder .jlbackup.conf, in the script directory, and create a
backup of SOURCE=, to DRIVE= at DEST_FOLDER=. For
example:

SOURCES=~/Desktop:~/Documents:~/Downloads:~/Music:~/opencat:~/Pictures:~/Videos:~/bin:
DRIVE=JCHL_1TB_Seagate
DEST_FOLDER=POP Home Rsync Backup

If the .jlbackup.conf file had this, it would save all SOURCE folders, seperated by :
colons, into a DEST_FOLDER or destination folder at the DRIVE location.

Mandatory arguments to long options are mandatory for short options too.
    -c --checksum           Enable differential backup by checksum (This takes
                            longer
    -d --dry                Set the backup to run as dry run, to show which
                            files will be backed up
    -S --sync               Delete files from destination directory that do not
                            match source directory. Warning, this is DANGEROUS,
                            recommended to do a dry run first. Can be useful,
                            but must be careful.
    -h --help               Display help (Currently displayed)
    -o --option [SOURCE]    Choose a specific folder to backup to cloud.
    -p --progress	    Display progress of data transfer

Examples:
    jlbackup.sh -c
    jlbackup.sh -dD
    END OF HELP'
}

# Use of Getopt
################################################################################
# Getopt to parse script and allow arg combinations ie. -yh instead of -h
# -y. Current accepted args are --yes --help --step
################################################################################
args=$(getopt -o cdShop -l checksum,dry,delete,help,sync,option,progress --name "$scriptname" -- "$@") 2>"$ERROR_FILE"

################################################################################
# If getopt outputs error to error variable, quit program displaying error
################################################################################
[ $? -eq 0 ] || {
    cat "$ERROR_FILE"
    echo 'Please use --help for more information'
    exit 1
}

# Set getopt parse backup into $@
################################################################################
# Arguments are parsed by getopt, are then set back into $@
################################################################################
# echo "$args"
eval set -- "$args"

################################################################################
# Case through each argument passed into script
# if no argument passed, default is -- and break loop
################################################################################
while true; do
    case "$1" in
    -c | --checksum)
        OPTIONS+=(-c); ;;
    -d | --dry)
        OPTIONS+=(--dry-run); ;;
    -S | --sync)
        SYNC_OPTION+=(--delete); ;;
    -p | --progess)
        OPTIONS+=(--progress); ;;
    -h | --help)
        print_help; exit 0; ;;
    -o | --option)
        OPTION_MODE=true; ;;
    --)
        shift; break; ;;
    *)
        echo "Programming error, this should not occur"; exit 1
    esac
    shift
done

# ONLY WORKS FOR PARSING DIRECTLY FROM TERMINAL
get_abs_filename() {
  # $1 : relative filename
  echo "$(cd "$(dirname "$1")" && pwd)/$(basename "$1")"
}

# Check for user option mode
################################################################################
# Check if user desires to backup specific file, if true then setup sources
################################################################################
if [[ $OPTION_MODE = true ]]; then
    if [ $# -eq 0 ]; then
        echo "$scriptname: ERROR, Must input argument for option -o"
        exit 1
    else
        for ((i=0; i=$#; i++)); do
            SOURCES+=("$(get_abs_filename $1)")
            shift
        done
    fi
fi

# Read data from file
###########################################################################
# Read file .jlbackup.conf line for line, and interpret SOURCE, DRIVE and
# Destination folder
###########################################################################
# store IFS for return later, IFS will be changed to : when intepreting
OIFS=$IFS
while IFS= read -r line; do
    # When line with SOURCES=, is found, read sources into list
    if [[ $(echo $line | grep 'SOURCES=') && -z $OPTION_MODE ]]; then
        # Line is reread without SOURCES=
        #line=$(echo $line | sed -e "s/^.*=//g")
        line="${line##*=}"
        IFS=':'
        RAW_SOURCES=($line)

        for SOURCE in ${RAW_SOURCES[@]}; do
            SOURCE=$(sed '/^~/!{q1}; s/^~//' <<< $SOURCE) && \
            SOURCE="$HOME$SOURCE"
            SOURCES+=("$SOURCE")
        done
        #echo "Sources are: ${SOURCES[@]}"; exit 0
        # Reset IFS
        IFS="$OIFS"
    # When line with DRIVE=, is found, read drive into DRIVE
    elif [[ $(echo $line | grep 'DRIVE=') ]]; then
        #line=$(echo $line | sed 's/^.*=//g')
        line="${line##*=}"
        DRIVE="$line"
        #echo "DRIVE is: "$DRIVE""
    # When line with DEST_FOLDER=, is found, read into DEST_FOLDER
    elif [[ $(echo $line | grep 'DEST_FOLDER=') ]]; then
        #line=$(echo $line | sed 's/^.*=//g')
        line="${line##*=}"
        DEST_FOLDER="$line"
        #echo "DEST_FOLDER is: "$DEST_FOLDER""
    fi
done < "$(dirname "$0")/.jlbackup.conf"
IFS=$OIFS

# Check Source files
################################################################################
# Check for the existance of source folders, else exit
################################################################################
SOURCE_LENGTH=${#SOURCES[@]}
for ((i=0; i<$SOURCE_LENGTH; i++)); do
    if [[ -f "${SOURCES[$i]}" ]]; then
        continue
    elif [[ -d "${SOURCES[$i]}" ]]; then
        SOURCES[$i]="${SOURCES[$i]}/"
    else
        echo "Source $FILE directory cannot be found!"
        exit 1
    fi
done

#echo "${SOURCES[@]}"; exit 0
# Check drive
################################################################################
# checks if drive is mounted in the mounts folder, -qs silents output
################################################################################
if grep -qs "$DRIVE" /proc/mounts; then
    # find drive destination
    DRIVE_DESTINATION="$(grep -oh "\S*$DRIVE\S*" /proc/mounts)"
    # Create destination folders for each source folder
    for SOURCE in ${SOURCES[@]}; do
        if [ -d "$SOURCE" ]; then
            DEST="$DRIVE_DESTINATION/$DEST_FOLDER/$(basename $SOURCE)"
            [ ! -d "$DEST" ] && mkdir -p "$DEST"
            DESTINATION+=("$DEST")
        else
            DEST="$DRIVE_DESTINATION/$DEST_FOLDER/Custom"
            [ ! -d "$DEST" ] && mkdir -p "$DEST"
            DESTINATION+=("$DEST/$(basename $SOURCE)")
        fi
    done
else
    echo "Drive '${DRIVE}' not mounted"
    exit 1
fi
#echo "${DESTINATION[@]}"; exit 0

# Indicate to user source and destination
echo "Beginning backup of key home folders..."
# Print each source on a new line
printf "%s\n" "${SOURCES[@]}"
echo "Sending to..."
echo "$DRIVE_DESTINATION/$DEST_FOLDER/"

echo '------------------------------------------------------------------------------'
for ((i=0; i<"${#SOURCES[@]}"; i++)); do
    echo '------------------------------------------------------------------------------'
    echo "Backing up ${SOURCES[$i]} to ${DESTINATION[$i]}"
    # Build backup command based on RSYNC
    RSYNC=(rsync -aAXv ${SYNC_OPTION:-'--backup'} --exclude='*.swp' --exclude='node_modules' --filter='P *~' "${OPTIONS[@]}" "${SOURCES[$i]}" "${DESTINATION[$i]}")
    #echo "${RSYNC[@]}"; exit 0
    "${RSYNC[@]}"
    echo '------------------------------------------------------------------------------'
done
echo '------------------------------------------------------------------------------'
# End timer
################################################################################
# Finish script, display time taken
################################################################################
echo 'Finished in H:'$(($SECONDS/3600))' M:'$(($SECONDS%3600/60))' S:'$(($SECONDS%60))
echo "Backup Complete"
exit 0
