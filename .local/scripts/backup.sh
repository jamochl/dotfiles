#!/bin/sh

R_OPTS="-axHzv"
R_DELETE="--delete"
BACKUP_DIR="james@192.168.1.230:/backup"
SOURCE_DIR="/home/james/"

sudo rsync "$R_OPTS" --delete --include={"/.config/"} \
    --exclude={"/.*/","/.config/Brave*","/.local/share/Steam/"} "$SOURCE_DIR" -e ssh "$BACKUP_DIR/home"

sudo rsync "$R_OPTS" \
    /var/lib/libvirt/images/* -e ssh \
    "$BACKUP_DIR/images"

sudo rsync "$R_OPTS" \
    /var/lib/libvirt/isos/* -e ssh \
    "$BACKUP_DIR/isos"
