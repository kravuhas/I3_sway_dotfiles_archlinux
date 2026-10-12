#!/usr/bin/env bash
DIR="$HOME/Pictures/Wallpapers"
THUMBS="$HOME/.cache/wallthumbs"
STATE="$HOME/.cache/current_wall"
mkdir -p "$THUMBS" "$HOME/.cache/awww"

is_video() { case "${1,,}" in *.mp4|*.webm|*.mkv|*.mov|*.gif) return 0;; esac; return 1; }

sway_colors() {
  [ -f "$HOME/.cache/wal/colors.sh" ] || return
  . "$HOME/.cache/wal/colors.sh"
  swaymsg "client.focused $color4 $color0 $foreground $color4 $color4" >/dev/null
  swaymsg "client.focused_inactive $color0 $background $foreground $color0 $color0" >/dev/null
  swaymsg "client.unfocused $color0 $background $foreground $color0 $color0" >/dev/null
}

apply() {
  f="$1"; colors="${2:-yes}"; trans="${3:-grow}"
  [ -f "$f" ] || exit 1
  pkill swaybg 2>/dev/null
  pgrep -x awww-daemon >/dev/null || { awww-daemon >/dev/null 2>&1 & sleep 1; }

  frame="$f"
  if is_video "$f"; then
    frame="$THUMBS/frame-$(basename "$f").png"
    [ -f "$frame" ] || ffmpeg -loglevel error -y -ss 1 -i "$f" -frames:v 1 "$frame"
    [ -f "$frame" ] || frame=""
  fi

  [ -n "$frame" ] && awww img "$frame" --transition-type "$trans" --transition-duration 1 --transition-fps 60

  if is_video "$f"; then
    old=$(pgrep -x mpvpaper)
    setsid mpvpaper -o "no-audio loop hwdec=auto panscan=1.0" '*' "$f" >/dev/null 2>&1 &
    sleep 1.5
    [ -n "$old" ] && kill $old 2>/dev/null
  else
    sleep 1.2
    pkill mpvpaper 2>/dev/null
  fi

  echo "$f" > "$STATE"

  if [ "$colors" = "yes" ] && [ -n "$frame" ]; then
    wal -i "$frame" -n -q -s -t
    sway_colors
    ~/.config/sway/scripts/apply-theme.sh
    pkill -SIGUSR2 waybar
    pkill -SIGUSR1 kitty
    notify-send "wallpaper" "$(basename "$f")" 2>/dev/null
  fi
}

menu() {
  find "$DIR" -maxdepth 1 -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' -o -iname '*.gif' -o -iname '*.mp4' -o -iname '*.webm' -o -iname '*.mkv' -o -iname '*.mov' \) | sort | while read -r f; do
    n=$(basename "$f"); t="$THUMBS/$n.png"
    if [ ! -f "$t" ]; then
      if is_video "$f"; then ss="-ss 1"; else ss=""; fi
      ffmpeg -loglevel error -y $ss -i "$f" -frames:v 1 -vf scale=400:-1 "$t" 2>/dev/null
    fi
    printf 'img:%s:text:%s\n' "$t" "$n"
  done
}

case "$1" in
  --restore) f=$(cat "$STATE" 2>/dev/null); [ -n "$f" ] && apply "$f" no none; sway_colors ;;
  --colors)  sway_colors ;;
  --set)     apply "$2" yes grow ;;
  *)
    sel=$(menu | wofi --dmenu --allow-images -c "$HOME/.config/wofi/wallsel.conf" -p "wall")
    [ -z "$sel" ] && exit 0
    apply "$DIR/${sel##*text:}" yes grow
    ;;
esac
