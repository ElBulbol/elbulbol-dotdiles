#!/bin/bash

LOCKFILE="/tmp/waybar_volume_popup.lock"

case $1 in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    mute)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
esac

# Create lockfile to show popup
touch "$LOCKFILE"

# Send signal to waybar to refresh instantly
pkill -RTMIN+8 waybar

# Remove lockfile after 2 seconds
(sleep 2 && rm -f "$LOCKFILE" && pkill -RTMIN+8 waybar) &
