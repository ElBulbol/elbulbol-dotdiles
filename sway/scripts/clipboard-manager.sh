#!/bin/bash

# Clipboard manager script using cliphist + wofi
# Toggle functionality - closes if open, opens if closed

# Check if wofi clipboard manager is already running
if pgrep -f "wofi.*Clipboard History" > /dev/null; then
    # If running, kill it (toggle off)
    pkill -f "wofi.*Clipboard History"
else
    # If not running, start it (toggle on)
    selected=$(cliphist list | wofi --dmenu -p "Clipboard History" \
        --width 300 \
        --height 400 \
        --xoffset -10 \
        --yoffset 10 \
        --location top_right \
        --style ~/.config/wofi/style.css \
        --conf ~/.config/wofi/config \
        --cache-file /dev/null)
    
    # If something was selected, decode and copy it to clipboard
    if [ -n "$selected" ]; then
        echo "$selected" | cliphist decode | wl-copy
        # Optional: Send notification that text was copied
        # notify-send "Clipboard" "Text copied to clipboard"
    fi
fi