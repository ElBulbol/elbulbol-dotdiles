#!/usr/bin/env bash
set -euo pipefail

# Create a new workspace next to the current one and switch to it.
# Usage: run from Sway keybinding.
# Log for debugging
LOG=/tmp/new-workspace-next.log
echo "---- $(date --iso-8601=seconds) invoked" >> "$LOG"

get_curr()
{
    if command -v jq >/dev/null 2>&1; then
        swaymsg -t get_workspaces | jq -r '.[] | select(.focused==true) | .num'
    else
        swaymsg -t get_workspaces | python3 - <<'PY'
import sys, json
ws = json.load(sys.stdin)
for w in ws:
    if w.get('focused'):
        print(w.get('num'))
        break
PY
    fi
}

curr=$(get_curr 2>>"$LOG" || true)
echo "curr raw: ${curr}" >> "$LOG"

if ! [[ "$curr" =~ ^[0-9]+$ ]]; then
    echo "failed to determine numeric workspace: '$curr'" >> "$LOG"
    exit 1
fi

next=$((curr + 1))
echo "switching to workspace $next" >> "$LOG"
swaymsg workspace number "$next" 2>>"$LOG"
echo "done" >> "$LOG"
