#!/usr/bin/env bash
if command -v awww >/dev/null; then A=awww; else A=swww; fi
DIR="$HOME/Pictures/Wallpapers"
pgrep -x "$A-daemon" >/dev/null || { "$A-daemon" & sleep 0.7; }
CHOICE=$(ls "$DIR" | wofi --dmenu --prompt "wallpaper") || exit 0
"$A" img "$DIR/$CHOICE" --transition-type wipe --transition-duration 1
