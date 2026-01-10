#!/bin/bash

LOCKFILE="/tmp/waybar_volume_popup.lock"

# Check if popup should be visible
[ ! -f "$LOCKFILE" ] && echo '{"text":"","class":"hidden"}' && exit 0

# Get current default sink
SINK=$(pactl get-default-sink)

# Check if it's bluetooth (headset) - optimized pattern
if [[ $SINK == *"bluez"* ]]; then
    CLASS="headset"
else
    CLASS="speaker"
fi

# Get volume and mute status in one call
VOLUME_INFO=$(pactl get-sink-volume @DEFAULT_SINK@)
VOLUME=${VOLUME_INFO%%\%*}
VOLUME=${VOLUME##* }
MUTED=$(pactl get-sink-mute @DEFAULT_SINK@)

if [[ $MUTED == *"yes"* ]]; then
    echo "{\"text\":\"VOL MUTED\",\"class\":\"$CLASS\"}"
    exit 0
fi

# Create modern thin volume bar (6 blocks) - optimized
BLOCKS=$(( (VOLUME * 6 + 99) / 100 ))
BAR=""
for ((i=1; i<=6; i++)); do
    (( i <= BLOCKS )) && BAR+="▰" || BAR+="▱"
done

echo "{\"text\":\"VOL $BAR $VOLUME%\",\"class\":\"$CLASS\"}"
