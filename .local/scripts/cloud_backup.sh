#!/bin/bash
#################################################################################
#                                 cloud-backup
#
#  Script to backup key home folders to cloud, specifically pCloud
#
#  Change History
#  2020 ~ 11/02/2020    James Lim   Preliminary code testing, implementing
#                                   file reading, getopt.
#  11/02/2020 James Lim  Documentation and minor edits
#  [Insert New]
#
################################################################################
################################################################################
#
#  Core Maintainer:  James C. H. Lim
#  Email:            james.lim.ori@gmail.com
#
################################################################################
################################################################################
#                                TODO LIST
#
################################################################################
################################################################################
# Time script
SECONDS=0
# Set script name for general file use
scriptname='cloud_backup'

# clean up script
################################################################################
# Remove any temporary files
################################################################################
clean_up() {
    rm -f "${ERROR_FILE[@]}"
    rm -f "${LOG_FILES[@]}"
}
trap clean_up EXIT
trap 'clean_up; kill 0' SIGINT
ERROR_FILE+=("$(mktemp)") || exit 1

# User help
################################################################################
# Prints user guide
################################################################################
print_help() {
    cat <<HEREDOC
Usage: cloud_backup [OPTION]
This script is an incremental backup command based on Rclone, which will backup
all of my desired key folders to pCloud, Google Drive, or both.

Mandatory arguments to long OPTIONS are mandatory for short OPTIONS too.
    -c --checksum           Enable differential backup by checksum (This takes
                            longer
    -d --dry                Set the backup to run as dry run, to show which
                            files will be backed up match source directory.
                            Warning, this is DANGEROUS, recommended to do a dry
                            run first. Can be useful, but must be careful.
    -g --GDrive	            Backup to Google Drive
    -p --pCloud             Backup to pCloud
    -a --all                Backup to all cloud drives (TIME CONSUMING)
    -h --help               Display help (Currently displayed)
    -o --option [SOURCE]    Choose a specific folder to backup to cloud.
    -s --sync	            Uses sync instead of copy to replicate conditions
                            between source files and destination files
    -m --multi-thread	    When multiple drive options are selected, this will
                            Multi-thread backing up to each cloud at the same
                            time. Does not allow verbose output. Output of each
                            thread can be followed by using command (tail -f)
                            on thread files at the script's location
Examples:
    cloud_backup.sh -cp
    cloud_backup.sh -dDg
    END OF HELP'
HEREDOC
}

# Use of Getopt
################################################################################
# Getopt to parse script and allow arg combinations ie. -yh instead of -h
# -y. Current accepted args are --yes --help --step
################################################################################
args=$(getopt -o cdhapgsom -l checksum,dry,help,all,pCloud,GDrive,sync,option,multi-thread --name "$scriptname" -- "$@") 2>"$ERROR_FILE"

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
eval set -- "$args"

################################################################################
# Case through each argument passed into script
# if no argument passed, default is -- and break loop
################################################################################
while true; do
    case "$1" in
    -c | --checksum)
        OPTIONS+=(-c); shift; ;;
    -d | --dry)
        OPTIONS+=(--dry-run); shift; ;;
    -h | --help)
        print_help; exit 0; ;;
    -a | --all)
        CLOUDS+=(GDrive); CLOUDS+=(pCloud); DRIVE_PICKED+=1; shift; ;;
    -p | --pCloud)
        CLOUDS+=(pCloud); DRIVE_PICKED+=1; shift; ;;
    -g | --GDrive)
        CLOUDS+=(GDrive); DRIVE_PICKED+=1; shift; ;;
    -s | --sync)
        BACKUP_MODE='sync'; shift; ;;
    -o | --option)
        shift; OPTION_MODE=true; ;;
    -m | --multi-thread)
        MULTI_THREAD=true; shift; ;;
    --)
        shift; break; ;;
    *)
        echo "Programming error, this should not occur"; exit 1; ;;
    esac
done

#echo "$@"

# Check valid options
################################################################################
# Check that a drive option is picked, if specific option is picked, and that
# sources exist
################################################################################
if [ "$DRIVE_PICKED" != 1 ]; then
    echo "Must pick one option, -a, -g or -p to backup!"
    exit 1
fi

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
            echo "$1"
            if [[ $(grep "^/" <<< "$1") ]]; then
                SOURCES+=("$1")
            elif [[ $(grep "^~/" <<< "$1") ]]; then
                SOURCES+=("$HOME/${1#\~/}")
            else
                SOURCES+=("$(pwd)/${1#./}")
            fi
            shift
        done
    fi
else
    SOURCES=(~/Desktop ~/Documents ~/Music ~/opencat ~/Pictures ~/Videos ~/bin ~/notes)
    #echo ${SOURCES[@]}
fi

# Check Source files
################################################################################
# Check for the existance of source folders, else exit
################################################################################
for FILE in ${SOURCES[@]}; do
    if [[ ! -d "$FILE" && ! -f "$FILE" ]]; then
        echo "Source $FILE cannot be found!"
        exit 1
    fi
done

# Create destination folders for each source folder
FOLDER="$(hostname)"
for SOURCE in ${SOURCES[@]}; do
    if [ -d "$SOURCE" ]; then
        DESTINATION+=("$FOLDER/$(basename $SOURCE)")
    elif [ -f "$SOURCE" ]; then
        DESTINATION+=("$FOLDER/Custom")
    else
        DESTINATION+=("$FOLDER/Custom/$(basename $SOURCE)")
    fi
done

# Begin Backup

#echo "${DESTINATION[@]}"; exit 0
# Indicate to user source and destination
echo "Beginning backup of folders..."
# Print each source on a new line
printf "%s\n" "${SOURCES[@]}"
echo "Sending to..."
printf "%s:\n" "${CLOUDS[@]}"
if [ ${#SOURCES[@]} -eq ${#DESTINATION[@]} ]; then
    SOURCE_LENGTH=${#SOURCES[@]}
else
    echo 'ERROR! EXITING'
    exit 1
fi

if [[ -z $MULTI_THREAD ]]; then
    for ((j=0; j<${#CLOUDS[@]}; j++)); do
        for ((i=0; i<$SOURCE_LENGTH; i++)); do
            echo "Backing up ${SOURCES[$i]} to ${CLOUDS[$j]}:${DESTINATION[$i]}"
            # Build backup command based on RSYNC
            RCLONE=(rclone "${BACKUP_MODE:=copy}" --transfers=8 --progress "${OPTIONS[@]}" "${SOURCES[$i]}" "${CLOUDS[$j]}:${DESTINATION[$i]}")
            #echo "${RCLONE[@]}"
            "${RCLONE[@]}"
        done
    done
else
    for ((j=0; j<${#CLOUDS[@]}; j++)); do
        LOG_FILES[$j]="$(mktemp)" || exit 1
        echo "Output for ${CLOUDS[$j]} is located in ${LOG_FILES[$j]}"
        { for ((i=0; i<$SOURCE_LENGTH; i++)); do
            echo "Backing up ${SOURCES[$i]} to ${CLOUDS[$j]}:${DESTINATION[$i]}"
            # Build backup command based on RSYNC
            RCLONE=(rclone "${BACKUP_MODE:=copy}" --transfers=8 --progress --stats=2s --stats-one-line "${OPTIONS[@]}" "${SOURCES[$i]}" "${CLOUDS[$j]}:${DESTINATION[$i]}")
            #echo "${RCLONE[@]}"
            #echo "Backing up ${SOURCES[$i]} to ${CLOUDS[$j]}:${DESTINATION[$i]}" >> ${LOG_FILES[$j]}
            "${RCLONE[@]}"
        done } &
    done
    #echo "do -> tail -f ${LOG_FILES[@]} <- to follow along"
    wait
fi

# End timer
################################################################################
# Finish script, display time taken
################################################################################
echo 'Finished in H:'$(($SECONDS/3600))' M:'$(($SECONDS%3600/60))' S:'$(($SECONDS%60))
echo "Backup Complete"
exit 0
