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


touch "$LOCKFILE"

# signal to waybar 
pkill -RTMIN+8 waybar


(sleep 2 && rm -f "$LOCKFILE" && pkill -RTMIN+8 waybar) &
