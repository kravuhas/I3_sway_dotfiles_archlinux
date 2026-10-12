#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Instalando dependências (Arch Linux)"
sudo pacman -S --needed --noconfirm \
  swayfx wofi kitty grim slurp swaybg swayidle swaylock \
  wl-clipboard brightnessctl playerctl pamixer jq python \
  fastfetch htop zsh papirus-icon-theme ttf-jetbrains-mono-nerd \
  noto-fonts-cjk

# Pacotes que normalmente vêm do AUR (quickshell, awww)
if command -v yay >/dev/null 2>&1; then
  AUR=yay
elif command -v paru >/dev/null 2>&1; then
  AUR=paru
fi
if [ -n "$AUR" ]; then
  $AUR -S --needed --noconfirm quickshell awww || \
    echo "AVISO: instale quickshell e awww manualmente."
else
  echo "AVISO: sem yay/paru. Instale 'quickshell' e 'awww' manualmente (AUR)."
fi

echo "==> Backup das configs atuais em $BACKUP"
mkdir -p "$BACKUP" "$HOME/.config"

for dir in sway waybar wofi kitty quickshell fastfetch; do
  src="$DOTFILES/.config/$dir"
  [ -d "$src" ] || continue
  [ -e "$HOME/.config/$dir" ] && mv "$HOME/.config/$dir" "$BACKUP/"
  cp -r "$src" "$HOME/.config/$dir"
done

chmod +x "$HOME/.config/sway/scripts/"* 2>/dev/null || true
chmod +x "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/wofi/"*.py 2>/dev/null || true

mkdir -p "$HOME/.images"
cp -n "$DOTFILES/.images/"* "$HOME/.images/" 2>/dev/null || true

echo "==> Pronto! Faça logout e entre no SwayFX."
echo "    Backup das configs antigas: $BACKUP"
