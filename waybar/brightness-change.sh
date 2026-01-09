#!/bin/bash

LOCKFILE="/tmp/waybar_brightness_popup.lock"

# Get current brightness percentage
CURRENT=$(brightnessctl get)
MAX=$(brightnessctl max)
PERCENT=$(( (CURRENT * 100) / MAX ))

case $1 in
    up)
        brightnessctl set +10%
        ;;
    down)
        # Only decrease if above 1%
        if [ $PERCENT -gt 1 ]; then
            brightnessctl set 10%-
            # Ensure we don't go below 1%
            NEW_CURRENT=$(brightnessctl get)
            NEW_PERCENT=$(( (NEW_CURRENT * 100) / MAX ))
            if [ $NEW_PERCENT -lt 1 ]; then
                brightnessctl set 1%
            fi
        fi
        ;;
esac

touch "$LOCKFILE"

# signal to waybar 
pkill -RTMIN+10 waybar

(sleep 2 && rm -f "$LOCKFILE" && pkill -RTMIN+10 waybar) &
