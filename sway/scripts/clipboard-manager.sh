#!/bin/bash

# Clipboard manager script using cliphist + wofi
# Similar to Windows Win+V clipboard history

cliphist list | wofi --dmenu -p "Clipboard History" \
    --width 600 \
    --height 400 \
    --xoffset -10 \
    --yoffset 10 \
    --location top_right \
    --style ~/.config/wofi/style.css \
    --conf ~/.config/wofi/config \
    --cache-file /dev/null \
    | cliphist decode | wl-copy