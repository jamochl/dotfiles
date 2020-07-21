#!/bin/sh
mem=$(free -m | awk 'NR==2 {print $3}')
echo "${mem}MiB"
