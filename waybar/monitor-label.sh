#!/bin/bash
# Returns the current focused output name/alias for Waybar
# Dependencies: swaymsg, jq

# Get the name of the focused output
focused=$(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name')

if [[ "$focused" == "eDP-1" ]]; then
    echo '{"text": "MAIN", "tooltip": "Primary Laptop Display", "class": "main"}'
elif [[ "$focused" == "HDMI-A-5" ]]; then
    echo '{"text": "SEC", "tooltip": "HP LE1711 Secondary", "class": "secondary"}'
else
    echo '{"text": "'"$focused"'", "tooltip": "Unknown Output", "class": "other"}'
fi
