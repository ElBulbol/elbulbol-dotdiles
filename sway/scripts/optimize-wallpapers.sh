#!/bin/sh
LOG="$HOME/.config/sway/sway-errors.log"

# Find ImageMagick convert (or magick) first
if command -v convert >/dev/null 2>&1; then
  IMGCMD=convert
elif command -v magick >/dev/null 2>&1; then
  IMGCMD="magick"
else
  echo "$(date) - ImageMagick 'convert' not found; skipping wallpaper optimization" >> "$LOG"
  exit 0
fi

WALLPAPERS="$HOME/.config/sway/wallpapers/wallpaper.png $HOME/.config/sway/wallpapers/wallpaper-1280_1024.png"

for src in $WALLPAPERS; do
  [ -f "$src" ] || continue
  dst="${src%.*}-optimized.png"
  "$IMGCMD" "$src" -colors 256 "$dst" 2>>"$LOG" || echo "$(date) - failed to optimize $src" >> "$LOG"
done

exit 0
