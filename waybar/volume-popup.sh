#!/bin/bash

LOCKFILE="/tmp/waybar_volume_popup.lock"

# Check if popup should be visible
if [ ! -f "$LOCKFILE" ]; then
    echo '{"text":"","class":"hidden"}'
    exit 0
fi

# Get volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

if [ "$MUTED" = "yes" ]; then
    echo '{"text":"MUTED","class":"visible"}'
    exit 0
fi

# Create volume bar (10 blocks)
BLOCKS=$((VOLUME / 10))
BAR=""
for i in {1..10}; do
    if [ $i -le $BLOCKS ]; then
        BAR+="━"
    else
        BAR+="━"
    fi
done

echo "{\"text\":\"$BAR $VOLUME%\",\"class\":\"visible\"}"
