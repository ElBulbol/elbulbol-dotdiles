#!/bin/bash
# Sway launcher with error logging
# Logs go to ~/.config/sway/sway-errors.log

LOGFILE="$HOME/.config/sway/sway-errors.log"

echo "" >> "$LOGFILE"
echo "========================================" >> "$LOGFILE"
echo "Sway STARTED: $(date)" >> "$LOGFILE"
echo "========================================" >> "$LOGFILE"

# Launch sway and log stderr to file
exec sway 2>&1 | tee -a "$LOGFILE"
