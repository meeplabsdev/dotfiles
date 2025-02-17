#!/bin/bash

if pgrep -x "waybar" > /dev/null; then
    pkill -x "waybar"
    uwsm app waybar
else
    uwsm app waybar
fi

