#!/bin/bash
# Simple wofi application launcher

# Toggle functionality - close if already open
if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

# Launch wofi in drun mode (application launcher)
wofi --show drun --config "$HOME/.config/wofi/config" --style "$HOME/.config/wofi/style.css" --prompt "Launch..." --insensitive
