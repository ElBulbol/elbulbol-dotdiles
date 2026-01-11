#!/bin/sh
# Safe launcher for swayidle + swaylock
LOG="$HOME/.config/sway/sway-errors.log"

#!/bin/sh
LOG="$HOME/.config/sway/sway-errors.log"

# Redirect script errors to the sway errors log
exec 2>>"$LOG"

# Kill any existing swayidle instances to avoid duplicates
if command -v pkill >/dev/null 2>&1; then
  pkill -x swayidle >/dev/null 2>&1 || true
else
  pids=$(pgrep -x swayidle || true)
  if [ -n "$pids" ]; then
    for pid in $pids; do
      kill -9 "$pid" >/dev/null 2>&1 || true
    done
  fi
fi

# Start swayidle only if available
if command -v swayidle >/dev/null 2>&1; then
  # Use a lightweight lock (solid black) instead of expensive blur/screenshot effects
  setsid swayidle -w \
    timeout 300 'swaylock -f -c 000000' \
    timeout 600 'swaymsg "output * dpms off"' \
    resume 'swaymsg "output * dpms on"' \
    before-sleep 'swaylock -f -c 000000' >/dev/null 2>&1 &
else
  echo "$(date) - swayidle not found; skipping" >> "$LOG"
fi

exit 0

exit 0
