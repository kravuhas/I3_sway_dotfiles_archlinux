#!/usr/bin/env bash
op=$(printf 'lock\nlogout\nsuspend\nreboot\nshutdown' | wofi --dmenu -c "$HOME/.config/wofi/wallsel.conf" --width 260 --height 260 --columns 1 -p "power")
case "$op" in
  lock) swaylock -f ;;
  logout) swaymsg exit ;;
  suspend) systemctl suspend ;;
  reboot) systemctl reboot ;;
  shutdown) systemctl poweroff ;;
esac
