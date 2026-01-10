#!/bin/bash

LOCKFILE="/tmp/waybar_brightness_popup.lock"

# Check if popup should be visible
[ ! -f "$LOCKFILE" ] && echo '{"text":"","class":"hidden"}' && exit 0

# Get current brightness percentage - optimized
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENT=$(( (BRIGHTNESS * 100) / MAX_BRIGHTNESS ))

# Create modern thin brightness bar (6 blocks) - optimized
BLOCKS=$(( (PERCENT * 6 + 99) / 100 ))
BAR=""
for ((i=1; i<=6; i++)); do
    (( i <= BLOCKS )) && BAR+="▰" || BAR+="▱"
done

echo "{\"text\":\"BRI $BAR $PERCENT%\",\"class\":\"brightness\"}"
