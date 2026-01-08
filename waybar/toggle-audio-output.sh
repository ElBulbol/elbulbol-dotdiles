#!/bin/bash

# Get all available sinks
SINKS=($(pactl list short sinks | awk '{print $2}'))
CURRENT=$(pactl get-default-sink)

# Find current sink index
for i in "${!SINKS[@]}"; do
    if [[ "${SINKS[$i]}" = "$CURRENT" ]]; then
        CURRENT_INDEX=$i
        break
    fi
done

# Calculate next sink index (cycle through)
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#SINKS[@]} ))
NEXT_SINK="${SINKS[$NEXT_INDEX]}"

# Set new default sink
pactl set-default-sink "$NEXT_SINK"

# Move all currently playing streams to new sink
pactl list short sink-inputs | awk '{print $1}' | while read stream; do
    pactl move-sink-input "$stream" "$NEXT_SINK"
done

# Send signal to waybar to update
pkill -RTMIN+8 waybar
