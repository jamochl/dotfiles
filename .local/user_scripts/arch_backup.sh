#!/bin/bash
cd ~/
dirs=(~/projects ~/notes ~/pictures ~/downloads ~/.local/extras ~/.local/scripts)
echo "Backing up: ${dirs[@]}"
$(rsync -aAXxv ${dirs[@]} /mnt/seagate/arch_backup/)
