#!/bin/bash
# Fast wofi launcher with web search fallback

# Toggle functionality - close if already open
if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

# Launch wofi in drun mode (faster, has built-in caching and icons)
selection=$(wofi --show drun --config "$HOME/.config/wofi/config" --style "$HOME/.config/wofi/style.css" --prompt "Search..." 2>/dev/null)

# Exit if cancelled or empty
[ -z "$selection" ] && exit 0

# Check if it's a recognized application by checking if a .desktop file with this name exists
if ! find /usr/share/applications ~/.local/share/applications -name "*.desktop" -exec grep -l "^Name=$selection$" {} \; 2>/dev/null | head -1 | read; then
    # Not an app - search web
    query=$(printf '%s' "$selection" | sed 's/ /+/g;s/&/%26/g')
    xdg-open "https://www.google.com/search?q=$query" 2>/dev/null &
fi
