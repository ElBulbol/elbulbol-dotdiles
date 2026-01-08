#!/bin/bash
# Sway launcher with error logging
# Logs go to ~/.config/sway/sway-errors.log

LOGFILE="$HOME/.config/sway/sway-errors.log"

echo "========================================" >> "$LOGFILE"
echo "Sway started: $(date)" >> "$LOGFILE"
echo "========================================" >> "$LOGFILE"

# Launch sway and capture stderr
exec sway 2>> "$LOGFILE"
