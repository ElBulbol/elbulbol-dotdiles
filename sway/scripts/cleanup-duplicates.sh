#!/bin/sh
LOG="$HOME/.config/sway/sway-errors.log"

# Kill duplicate swayidle processes (keep only first)
pids=$(pgrep -x swayidle || true)
if [ -n "$pids" ]; then
  set -- $pids
  # drop first to keep it
  shift
  for pid in "$@"; do
    kill -9 "$pid" >/dev/null 2>&1 || true
  done
fi

# Kill duplicate ssh-agent processes (keep only first)
ssh_pids=$(pgrep -x ssh-agent || true)
if [ -n "$ssh_pids" ]; then
  set -- $ssh_pids
  shift
  for pid in "$@"; do
    kill -9 "$pid" >/dev/null 2>&1 || true
  done
fi

# Kill all swaybg instances (they will be restarted if needed)
pkill -x swaybg >/dev/null 2>&1 || true

# Clear the sway errors log but keep the file
: > "$LOG"

# Notify user
if command -v notify-send >/dev/null 2>&1; then
  notify-send "Sway cleanup" "Duplicates removed and sway-errors.log cleared"
fi

exit 0
