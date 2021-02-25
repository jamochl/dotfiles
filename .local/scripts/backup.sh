#!/bin/sh

R_OPTS="-axAXHv"
R_DELETE="--delete"
BACKUP_DIR="backup@192.168.1.215:metabox_14/"
SOURCE_DIR="/home/james/"

rsync "$R_OPTS" "$R_DELETE" --include={"/.local/","/.config/","/.ssh/"} --exclude="/.*/" "$SOURCE_DIR" -e ssh "$BACKUP_DIR"
