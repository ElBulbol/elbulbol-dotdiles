#!/bin/bash

# Get current default sink
SINK=$(pactl get-default-sink)

# Check if it's bluetooth
if echo "$SINK" | grep -q "bluez"; then
    echo '{"text":"BT","class":"bluetooth"}'
else
    echo '{"text":"SPK","class":"speaker"}'
fi
