#!/usr/bin/env bash
if command -v awww >/dev/null; then A=awww; else A=swww; fi
DIR="$HOME/Pictures/Wallpapers"
pgrep -x "$A-daemon" >/dev/null || { "$A-daemon" & sleep 0.7; }
IMG=$(find "$DIR" -type f \( -iname '*.jpg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n1)
"$A" img "$IMG" --transition-type grow --transition-duration 1
