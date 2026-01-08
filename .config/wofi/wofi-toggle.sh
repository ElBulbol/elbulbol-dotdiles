#!/bin/bash

# Check if wofi is running
if pgrep -x wofi > /dev/null; then
    # Kill wofi if running
    pkill wofi
else
    # Launch wofi
    wofi --show drun
fi
