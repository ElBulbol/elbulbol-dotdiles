#!/bin/bash

# Check if blueman is running
if pgrep -f "blueman" > /dev/null; then
    # Kill all blueman processes
    pkill -9 -f "blueman"
else
    # Launch blueman-manager
    blueman-manager &
fi
