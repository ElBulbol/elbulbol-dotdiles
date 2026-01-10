#!/bin/bash

# Get current default sink
SINK=$(pactl get-default-sink)

# Determine device type and class - optimized with bash pattern matching
if [[ $SINK == *"bluez"* ]] || [[ $SINK == *"bluetooth"* ]]; then
    CLASS="headset"
    DEVICE="BT"
elif [[ $SINK == *"hdmi"* ]] || [[ $SINK == *"HDMI"* ]]; then
    CLASS="headset"
    DEVICE="HDMI"
else
    CLASS="speaker"
    DEVICE="SPK"
fi

echo "{\"text\":\"$DEVICE\",\"class\":\"$CLASS\"}"
