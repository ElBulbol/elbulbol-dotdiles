#!/bin/bash

# Toggle wofi (show drun). Use explicit config and style paths to ensure appearance.
if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

WOFI_CONF="$HOME/.config/wofi/config"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Launch wofi with the config and style, allow images and icons
exec wofi --config "$WOFI_CONF" --show drun --style "$WOFI_STYLE"
