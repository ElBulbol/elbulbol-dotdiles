#!/bin/bash
# Sway config reload with error logging and notification
# Logs all errors to ~/.config/sway/sway-errors.log

LOGFILE="$HOME/.config/sway/sway-errors.log"
CONFIG="$HOME/.config/sway/config"

echo "" >> "$LOGFILE"
echo "========================================" >> "$LOGFILE"
echo "Config reload: $(date)" >> "$LOGFILE"
echo "========================================" >> "$LOGFILE"

# Validate config and capture output
OUTPUT=$(swaymsg reload 2>&1)

# Check if reload was successful (look for "success": true in JSON)
if echo "$OUTPUT" | grep -q '"success": true'; then
    echo "Status: OK - Reloaded successfully" >> "$LOGFILE"
    notify-send -u normal -t 3000 "Sway Config" "Reloaded successfully ✓"
else
    # Log errors
    echo "$OUTPUT" >> "$LOGFILE"
    echo "Status: ERRORS FOUND" >> "$LOGFILE"
    
    # Show notification with error
    notify-send -u critical -t 10000 "Sway Config Error" "$OUTPUT"
fi
