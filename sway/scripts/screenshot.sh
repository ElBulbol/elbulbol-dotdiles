#!/bin/bash

# ============================================
# Screenshot Script for Sway (Wayland)
# Supports: Area selection, clipboard, timestamped files
# Keybinding: Win+Shift+S
# ============================================

# Create screenshots directory if it doesn't exist
SCREENSHOT_DIR="$HOME/screenshots"
mkdir -p "$SCREENSHOT_DIR" || {
    notify-send -u critical "Screenshot Error" "Failed to create directory: $SCREENSHOT_DIR"
    exit 1
}

# Generate filename with timestamp (simple and readable format)
# Format: 2026-01-09_14-30-45.png
TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
FILENAME="$SCREENSHOT_DIR/${TIMESTAMP}.png"

# Check if required tools are installed
if ! command -v grim &> /dev/null; then
    notify-send -u critical "Screenshot Error" "grim is not installed. Install it with: sudo pacman -S grim"
    exit 1
fi

if ! command -v slurp &> /dev/null; then
    notify-send -u critical "Screenshot Error" "slurp is not installed. Install it with: sudo pacman -S slurp"
    exit 1
fi

if ! command -v wl-copy &> /dev/null; then
    notify-send -u critical "Screenshot Error" "wl-clipboard is not installed. Install it with: sudo pacman -S wl-clipboard"
    exit 1
fi

# Take screenshot of selected region
# slurp lets you select an area, grim captures it
SELECTION=$(slurp 2>&1)
if [ $? -ne 0 ]; then
    # User cancelled or slurp failed
    exit 0
fi

grim -g "$SELECTION" "$FILENAME"

# Check if screenshot was successful
if [ $? -eq 0 ] && [ -f "$FILENAME" ]; then
    # Copy to clipboard (both for cliphist and direct paste)
    wl-copy < "$FILENAME"
    
    # Also store in cliphist if available (for Win+V clipboard manager)
    if command -v cliphist &> /dev/null; then
        wl-copy < "$FILENAME"
    fi
    
    # Show success notification
    if command -v notify-send &> /dev/null; then
        notify-send -i "$FILENAME" "Screenshot Saved" "Saved to: ${TIMESTAMP}.png\nCopied to clipboard"
    fi
else
    # Show error notification
    if command -v notify-send &> /dev/null; then
        notify-send -u critical "Screenshot Error" "Failed to save screenshot"
    fi
    exit 1
fi
