#!/bin/bash

# Check if blueman-manager window is already running
if pgrep -f blueman-manager > /dev/null; then
    # If running, kill all blueman processes (manager, applet, tray)
    pkill -9 -f blueman-manager
    pkill -9 -f blueman-applet
    pkill -9 -f blueman-tray
else
    # If not running, start it
    blueman-manager &
fi
