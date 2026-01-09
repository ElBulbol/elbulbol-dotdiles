#!/bin/bash

# Toggle wofi (show drun). Use explicit config and style paths to ensure appearance.
if pgrep -x wofi > /dev/null; then
    pkill wofi
    exit 0
fi

WOFI_CONF="$HOME/.config/wofi/config"
WOFI_STYLE="$HOME/.config/wofi/style.css"

# Launch wofi with frecency tracking and performance optimization
exec wofi --show drun --config "$WOFI_CONF" --style "$WOFI_STYLE" --normal-window
