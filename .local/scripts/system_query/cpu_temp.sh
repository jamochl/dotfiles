#! /bin/sh
sensors -A | awk '/skylake/ { getline; print $2; }'
