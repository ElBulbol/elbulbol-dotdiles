#!/bin/bash

LOCKFILE="/tmp/waybar_brightness_popup.lock"

case $1 in
    up)
        brightnessctl set +10%
        ;;
    down)
        # Get current brightness percentage
        CURRENT=$(brightnessctl get)
        MAX=$(brightnessctl max)
        PERCENT=$(( (CURRENT * 100) / MAX ))
        
        # Only decrease if above 1%
        if [ $PERCENT -gt 1 ]; then
            brightnessctl set 10%-
            # Ensure we don't go below 1%
            NEW_CURRENT=$(brightnessctl get)
            NEW_PERCENT=$(( (NEW_CURRENT * 100) / MAX ))
            [ $NEW_PERCENT -lt 1 ] && brightnessctl set 1%
        fi
        ;;
esac

touch "$LOCKFILE"
pkill -RTMIN+10 waybar

# Use exec to replace shell with sleep, reducing process count
(sleep 2; rm -f "$LOCKFILE"; pkill -RTMIN+10 waybar) &
