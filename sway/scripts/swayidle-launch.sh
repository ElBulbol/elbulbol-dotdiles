#!/bin/sh
# Safe launcher for swayidle + swaylock
LOG="$HOME/.config/sway/sway-errors.log"

if command -v swayidle >/dev/null 2>&1; then
  swayidle -w \
    timeout 300 'swaylock -f -c 000000' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock -f -c 000000' >/dev/null 2>&1 &
else
  echo "$(date) - swayidle not found; skipping" >> "$LOG"
fi

exit 0
