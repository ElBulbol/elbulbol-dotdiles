#!/bin/bash
# Wofi launcher with web search fallback
# Features: Caching for speed, Web search for non-apps, Proper error handling

CACHE_DIR="$HOME/.cache/wofi"
CACHE_FILE="$CACHE_DIR/apps.list"
STYLE_FILE="$HOME/.config/wofi/style.css"

# Ensure cache directory exists
mkdir -p "$CACHE_DIR"

# Function to rebuild cache
rebuild_cache() {
    # Temp file for building
    TEMP_FILE="${CACHE_FILE}.tmp"
    : > "$TEMP_FILE"

    # Search paths for .desktop files
    IFS=':' read -ra DIRS <<< "${XDG_DATA_DIRS:-/usr/local/share:/usr/share}"
    SEARCH_DIRS=("$HOME/.local/share/applications" "${DIRS[@]/%//applications}")

    for dir in "${SEARCH_DIRS[@]}"; do
        [ -d "$dir" ] || continue
        find "$dir" -maxdepth 2 -name "*.desktop" 2>/dev/null | while read -r desktop; do
            # Skip hidden apps
            if grep -q "^NoDisplay=true" "$desktop"; then continue; fi

            # Extract Name and Icon using simple parsing
            name=$(grep -m 1 "^Name=" "$desktop" | cut -d= -f2-)
            icon=$(grep -m 1 "^Icon=" "$desktop" | cut -d= -f2-)

            [ -z "$name" ] && continue
            
            # Sanitize name (remove pipes if any to avoid delimiter conflict)
            name=${name//|/-}
            
            # Save: Name|Path|Icon
            echo "$name|$desktop|$icon" >> "$TEMP_FILE"
        done
    done

    # Sort by name and remove duplicates (keeping first occurrence)
    sort -u -t'|' -k1,1 "$TEMP_FILE" > "$CACHE_FILE"
    rm -f "$TEMP_FILE"
}

# Rebuild cache if missing (User can delete this file to force rebuild)
[ ! -f "$CACHE_FILE" ] && rebuild_cache

# Run wofi
# 1. Provide list from cache
# 2. Use dmenu mode to allow custom input
# 3. Capture output
selection=$(awk -F'|' '{print $1 "\x00icon\x1f" $3}' "$CACHE_FILE" | \
    wofi --dmenu \
         --style "$STYLE_FILE" \
         --cache-file /dev/null \
         --prompt "Search..." \
         --width 700 \
         --height 450 \
         --insensitive \
         --allow-images \
         --image-size 24)

exit_code=$?

# Exit if cancelled (Esc) or empty
if [ $exit_code -ne 0 ] || [ -z "$selection" ]; then
    exit 0
fi

# Fix for "Canceled" string issue (if wofi returns it erroneously)
if [ "$selection" = "Canceled" ]; then
    exit 0
fi

# Check if selected item is an app in our list
# grep returns 0 if found
cwd_match=$(grep -F -m 1 "$selection|" "$CACHE_FILE")

if [ -n "$cwd_match" ]; then
    # It's an application
    # Extract desktop file path
    desktop_file=$(echo "$cwd_match" | cut -d'|' -f2)
    # Launch
    gtk-launch "$(basename "$desktop_file" .desktop)" >/dev/null 2>&1 &
else
    # It's not an application -> Web Search
    # Encode query
    query=$(echo "$selection" | sed -e 's/ /+/g' -e 's/&/%26/g')
    xdg-open "https://www.google.com/search?q=$query" >/dev/null 2>&1 &
fi
