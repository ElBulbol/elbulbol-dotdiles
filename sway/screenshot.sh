#!/bin/bash

# Create screenshots directory if it doesn't exist
SCREENSHOT_DIR="$HOME/screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Generate filename with timestamp
FILENAME="$SCREENSHOT_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

# Take screenshot of selected region
grim -g "$(slurp)" "$FILENAME"

# Copy to clipboard
wl-copy < "$FILENAME"

# Optional: Show notification (requires mako)
if command -v notify-send &> /dev/null; then
    notify-send "Screenshot saved" "$FILENAME"
fi
