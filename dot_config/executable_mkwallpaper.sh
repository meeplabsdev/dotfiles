#!/bin/bash

if [ -e "$1" ]; then
    WALLPAPER="$1"
else
    echo "Error: '$1' is not valid"
    exit 1
fi

wal -i $WALLPAPER -n
swaymsg output "*" background $(< "${HOME}/.cache/wal/wal") fill

pywalfox update
killall walker || true
uwsm app walker -- --gapplication-service
uwsm app walker -- --modules applications
