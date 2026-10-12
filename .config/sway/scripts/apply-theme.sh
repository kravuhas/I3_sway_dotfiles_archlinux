#!/usr/bin/env bash
[ -f "$HOME/.cache/wal/colors.sh" ] || exit 0
. "$HOME/.cache/wal/colors.sh"
rgb() { printf "%d,%d,%d" "0x${1:1:2}" "0x${1:3:2}" "0x${1:5:2}"; }

BG=$(rgb "$background"); ALT=$(rgb "$color0"); FG=$(rgb "$foreground")
DIM=$(rgb "$color8"); AC=$(rgb "$color4"); AC2=$(rgb "$color5")

sec() { cat <<XX
[Colors:$1]
BackgroundNormal=$2
BackgroundAlternate=$ALT
ForegroundNormal=$FG
ForegroundInactive=$DIM
ForegroundActive=$AC2
ForegroundLink=$AC
ForegroundVisited=$AC2
ForegroundNegative=255,77,109
ForegroundNeutral=255,184,108
ForegroundPositive=126,224,181
DecorationFocus=$AC
DecorationHover=$AC2

XX
}

{
  sec View "$BG"
  sec Window "$BG"
  sec Button "$ALT"
  sec Tooltip "$BG"
  sec Complementary "$BG"
  sec Header "$BG"
  cat <<XX
[Colors:Selection]
BackgroundNormal=$AC
BackgroundAlternate=$AC2
ForegroundNormal=$(rgb "$background")
ForegroundInactive=$(rgb "$background")
ForegroundActive=$(rgb "$background")
ForegroundLink=$(rgb "$background")
ForegroundVisited=$(rgb "$background")
ForegroundNegative=255,77,109
ForegroundNeutral=255,184,108
ForegroundPositive=126,224,181
DecorationFocus=$AC
DecorationHover=$AC2

[General]
ColorScheme=wal

[Icons]
Theme=Papirus-Dark

[KDE]
widgetStyle=Breeze
XX
} > "$HOME/.config/kdeglobals"
cp "$HOME/.config/kdeglobals" "$HOME/.local/share/color-schemes/wal.colors"

# wofi (launcher Super+D, seletor de wallpaper e menu de energia)
cat > "$HOME/.config/wofi/style.css" <<XX
* { font-family: "JetBrainsMono Nerd Font"; font-size: 14px; }
window { background-color: $background; border: 2px solid $color4; border-radius: 12px; }
#input { margin: 8px; padding: 6px 10px; background: $color0; color: $foreground; border: 1px solid $color8; border-radius: 8px; }
#inner-box, #outer-box, #scroll { background: transparent; }
#entry { padding: 6px; margin: 2px 6px; color: $foreground; border-radius: 8px; }
#entry:selected { background-color: $color4; color: $background; }
#text:selected { color: $background; }
XX
