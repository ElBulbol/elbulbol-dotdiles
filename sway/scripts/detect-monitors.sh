#!/bin/bash
# Detect and display connected monitors
# Run this to find the correct output names for sway config

echo "=== Connected Outputs ==="
swaymsg -t get_outputs | jq -r '.[] | "Output: \(.name)\n  Make: \(.make)\n  Model: \(.model)\n  Resolution: \(.current_mode.width)x\(.current_mode.height)@\(.current_mode.refresh/1000)Hz\n  Position: \(.rect.x),\(.rect.y)\n  Active: \(.active)\n"'

echo ""
echo "=== Quick Reference ==="
echo "Copy these output names to your sway config:"
swaymsg -t get_outputs | jq -r '.[] | .name' | while read output; do
    echo "  $output"
done

echo ""
echo "=== If VGA monitor not detected ==="
echo "Your LE1711 VGA monitor might appear as:"
echo "  - VGA-1 (most common)"
echo "  - VGA-2"
echo "  - DP-1 (if using VGA-to-DP adapter)"
echo ""
echo "Update \$secondary in ~/.config/sway/config accordingly"
