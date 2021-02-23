#!/bin/bash
# A script to clean up old kernel modules (not current kernel and not
# newly installed) in the /usr/lib/modules directory. Necessary as I
# want to be able to continue using the PC after a kernel update

# Install in /etc/pacman.d/scripts
# Call from a alpm path post-hook at /etc/pacman.d/hooks

set -e

CURRENT_KERN="$(uname -r)"
# LINUX and LINUX_LTS actually do not give exactly the correct values,
# the pacman version is eg. 5.10.3.arch1-1, but the module directory
# name is 5.10.3-arch1-1. In a regular expression with grep this is
# fine, because a dot globs every character, but it will not work with
# the `ls` --hide option unless you process the version to change the
# '.' to a '-', which is not worth it
LINUX="$(pacman -Qi linux | awk '/Version/ { print $3 }')"
LINUX_LTS="$(pacman -Qi linux-lts | awk '/Version/ { print $3 "-lts" }')"
OLD_MODULES="$(ls /usr/lib/modules | grep -e "$LINUX" -e "$LINUX_LTS" -e "$CURRENT_KERN" --invert-match)"

cd /usr/lib/modules
echo "==> Current working directory: $(pwd)"
echo "==> Removing old kernel modules..."
for MODULE in $OLD_MODULES; do
    echo "==> Deleting $(pwd)/$MODULE"
    sudo rm -rf "$MODULE"
done
