#!/bin/bash

LOCKFILE="/tmp/waybar_brightness_popup.lock"

# Check if popup should be visible
if [ ! -f "$LOCKFILE" ]; then
    echo '{"text":"","class":"hidden"}'
    exit 0
fi

# Get current brightness percentage
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENT=$(( (BRIGHTNESS * 100) / MAX_BRIGHTNESS ))

# Create modern thin brightness bar (6 blocks)
BLOCKS=$(( (PERCENT * 6 + 99) / 100 ))
BAR=""
for i in {1..6}; do
    if [ $i -le $BLOCKS ]; then
        BAR+="▰"
    else
        BAR+="▱"
    fi
done

echo "{\"text\":\"BRI $BAR $PERCENT%\",\"class\":\"brightness\"}"
