#!/bin/bash

# Get current default sink
SINK=$(pactl get-default-sink)

# Determine device type and class
if echo "$SINK" | grep -qi "bluez\|bluetooth"; then
    CLASS="headset"
    # Extract bluetooth device name (simplified)
    DEVICE="BT"
elif echo "$SINK" | grep -qi "hdmi"; then
    CLASS="headset"
    DEVICE="HDMI"
else
    CLASS="speaker"
    DEVICE="SPK"
fi

echo "{\"text\":\"$DEVICE\",\"class\":\"$CLASS\"}"
