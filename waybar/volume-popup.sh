#!/bin/bash

LOCKFILE="/tmp/waybar_volume_popup.lock"

# Check if popup should be visible
if [ ! -f "$LOCKFILE" ]; then
    echo '{"text":"","class":"hidden"}'
    exit 0
fi

# Get current default sink
SINK=$(pactl get-default-sink)

# Check if it's bluetooth (headset)
if echo "$SINK" | grep -q "bluez"; then
    CLASS="headset"
else
    CLASS="speaker"
fi

# Get volume
VOLUME=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -Po '\d+(?=%)' | head -1)
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

if [ "$MUTED" = "yes" ]; then
    echo "{\"text\":\"VOL MUTED\",\"class\":\"$CLASS\"}"
    exit 0
fi

# Create modern thin volume bar (6 blocks)
BLOCKS=$(( (VOLUME * 6 + 99) / 100 ))
BAR=""
for i in {1..6}; do
    if [ $i -le $BLOCKS ]; then
        BAR+="▰"
    else
        BAR+="▱"
    fi
done

echo "{\"text\":\"VOL $BAR $VOLUME%\",\"class\":\"$CLASS\"}"
