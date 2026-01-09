#!/bin/bash

# Toggle wofi if already running
if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

WOFI_CONF="$HOME/.config/wofi/config"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Create a wrapper that captures input but doesn't execute
export LAUNCHER_CAPTURE=1

# Launch wofi in drun mode, capturing the desktop entry ID
result=$(wofi --show drun --config "$WOFI_CONF" --style "$WOFI_STYLE" --print-command 2>/dev/null)

# Exit if canceled/nothing selected
exit_code=$?
if [[ $exit_code -ne 0 ]] || [[ -z "$result" ]]; then
    exit 0
fi

# If result looks like a command from a .desktop file, execute it
if [[ "$result" =~ ^/ ]] || command -v "$(echo "$result" | awk '{print $1}')" &>/dev/null; then
    # It's a valid command, execute it
    bash -c "$result" &
else
    # Not a command - treat as web search
    query=$(echo "$result" | sed 's/ /+/g' | sed 's/&/%26/g')
    xdg-open "https://www.google.com/search?q=$query" 2>/dev/null &
fi
