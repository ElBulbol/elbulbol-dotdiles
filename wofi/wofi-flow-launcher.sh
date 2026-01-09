#!/bin/bash

# Lightweight Flow Launcher style wofi with icons and web search fallback

if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

# Launch wofi in drun mode with web search fallback
selection=$(wofi --show drun --prompt "Search:" --insensitive 2>&1)

# If selection failed or empty, try web search
if [[ $? -ne 0 ]] || [[ -z "$selection" ]]; then
    # Get custom input for web search
    query=$(echo "" | wofi --dmenu --prompt "Search web:" --insensitive --cache-file /dev/null)
    [[ -n "$query" ]] && xdg-open "https://www.google.com/search?q=${query// /+}" &
fi
