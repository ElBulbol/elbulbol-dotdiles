#!/bin/sh
# Safe launcher for mako notifications
LOG="$HOME/.config/sway/sway-errors.log"

if command -v mako >/dev/null 2>&1; then
  setsid mako >/dev/null 2>&1 &
else
  echo "$(date) - mako not found; skipping" >> "$LOG"
fi

exit 0
