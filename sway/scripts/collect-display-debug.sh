#!/bin/bash
OUTDIR="$HOME/.config/sway/debug-outputs"
mkdir -p "$OUTDIR"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILE="$OUTDIR/display-$TIMESTAMP.txt"
{
  echo "== get_outputs =="
  swaymsg -t get_outputs
  echo "\n== get_workspaces =="
  swaymsg -t get_workspaces
  echo "\n== get_tree (first-level) =="
  swaymsg -t get_tree | jq '.nodes[] | {name,type,rect,focused,output}'
  echo "\n== sway-errors.log tail =="
  tail -n 200 "$HOME/.config/sway/sway-errors.log" 2>/dev/null
  echo "\n== journalctl last 200 lines for sway (if available) =="
  journalctl -u sway -n 200 --no-pager 2>/dev/null || true
  echo "\n== dmesg tail 200 lines =="
  dmesg | tail -n 200
} > "$FILE" 2>&1

echo "Diagnostics collected to: $FILE"
