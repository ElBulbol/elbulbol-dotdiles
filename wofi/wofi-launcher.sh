#!/bin/bash

# Wofi launcher with web search fallback - like Flow Launcher

if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

WOFI_CONF="$HOME/.config/wofi/config"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Get desktop applications in a format wofi can use
get_apps() {
    find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | while read -r f; do
        name=$(grep -m 1 "^Name=" "$f" | cut -d'=' -f2)
        nodisplay=$(grep -m 1 "^NoDisplay=" "$f" | cut -d'=' -f2)
        [ "$nodisplay" = "true" ] && continue
        [ -n "$name" ] && echo "$name"
    done | sort -u
}

# Show apps and get selection
selection=$(get_apps | wofi --dmenu --config "$WOFI_CONF" --style "$WOFI_STYLE" --cache-file=/dev/null --prompt "Run:")

[ -z "$selection" ] && exit 0

# Try to launch as application
launched=false
find /usr/share/applications ~/.local/share/applications -name "*.desktop" 2>/dev/null | while read -r f; do
    name=$(grep -m 1 "^Name=" "$f" | cut -d'=' -f2)
    if [ "$name" = "$selection" ]; then
        gtk-launch "$(basename "$f" .desktop)" 2>/dev/null && launched=true
        break
    fi
done

# If not an app, search web
if [ "$launched" = "false" ]; then
    query=$(echo "$selection" | sed 's/ /+/g' | sed 's/&/%26/g')
    xdg-open "https://www.google.com/search?q=$query" 2>/dev/null &
fi
