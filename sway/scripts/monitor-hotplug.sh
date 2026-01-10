#!/usr/bin/env bash
# Monitor hotplug watcher for Sway - auto-enable the known external monitor
# Requires: jq, swaymsg

# Prefer identifying the monitor by make/model so connector renames won't break the script
TARGET=""
PREFERRED_WIDTH=1280
PREFERRED_HEIGHT=1024
POSITION="1920,0"

# If jq/swaymsg missing, exit
command -v swaymsg >/dev/null || exit 0
command -v jq >/dev/null || exit 0

# Helper: enable correct mode for the target output
enable_output() {
  # Determine a sane mode for the target: prefer the configured preferred resolution,
  # otherwise fall back to the current_mode reported by sway.
  mode_str=""
  modes_json=$(swaymsg -t get_outputs | jq -r --arg t "$TARGET" '.[] | select(.name==$t)')
  if [[ -n "$modes_json" ]]; then
    # Try to find preferred resolution in the modes list
    mode_match=$(jq -r --arg w "$PREFERRED_WIDTH" --arg h "$PREFERRED_HEIGHT" '.modes[] | select(.width==($w|tonumber) and .height==($h|tonumber)) | "\(.width)x\(.height)@\(.refresh/1000)Hz"' <<<"$modes_json" | head -n1)
    if [[ -n "$mode_match" ]]; then
      mode_str="$mode_match"
    else
      # Fallback to current_mode
      mode_str=$(jq -r '.current_mode | "\(.width)x\(.height)@\(.refresh/1000)Hz"' <<<"$modes_json")
    fi
  fi

  if [[ -n "$mode_str" ]]; then
    swaymsg output "$TARGET" enable mode "$mode_str" position $POSITION >/dev/null 2>&1 || true
  else
    swaymsg output "$TARGET" enable position $POSITION >/dev/null 2>&1 || true
  fi
  swaymsg output "$TARGET" dpms on >/dev/null 2>&1 || true
}

# On start: dynamically find the target by make/model, otherwise first HDMI output
if command -v jq >/dev/null 2>&1; then
  # Try to find by known make/model (common for user's HP LE1711)
  TARGET=$(swaymsg -t get_outputs | jq -r '.[] | select(.make=="Hewlett Packard" or .model=="LE1711") | .name' | head -n1)
  if [[ -z "$TARGET" ]]; then
    # Fallback to first HDMI connector available
    TARGET=$(swaymsg -t get_outputs | jq -r '.[] | select(.name|test("HDMI")) | .name' | head -n1)
  fi

  if [[ -n "$TARGET" ]]; then
    active=$(swaymsg -t get_outputs | jq -r --arg t "$TARGET" '.[] | select(.name==$t) | .active')
    if [[ "$active" == "true" ]]; then
      enable_output
    fi
  fi
fi

# Subscribe to output events and react to changes
swaymsg -t subscribe '["output"]' | while read -r ev; do
  # Only handle events that include an output object
  if ! echo "$ev" | jq -e 'has("output")' >/dev/null 2>&1; then
    continue
  fi
  name=$(echo "$ev" | jq -r '.output.name // ""')
  # If we don't yet have a target, try to set it when a matching device appears
  if [[ -z "$TARGET" ]]; then
    # Match by make/model or HDMI prefix
    make=$(echo "$ev" | jq -r '.output.make // empty')
    model=$(echo "$ev" | jq -r '.output.model // empty')
    if [[ "$make" == "Hewlett Packard" || "$model" == "LE1711" || "$name" =~ HDMI ]]; then
      TARGET="$name"
    fi
  fi

  if [[ "$name" != "$TARGET" ]]; then
    continue
  fi

  active=$(echo "$ev" | jq -r '.output.active // empty')
  # When the target becomes active, set mode and dpms
  if [[ "$active" == "true" ]]; then
    enable_output
  fi
done
