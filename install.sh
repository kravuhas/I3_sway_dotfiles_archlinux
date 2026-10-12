#!/usr/bin/env bash
set -e

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
BACKUP="$HOME/.config-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Instalando dependências (Arch Linux)"
sudo pacman -S --needed --noconfirm \
  swayfx waybar wofi kitty grim slurp swaybg swayidle swaylock \
  wl-clipboard brightnessctl playerctl pamixer jq python \
  papirus-icon-theme ttf-jetbrains-mono-nerd

echo "==> Fazendo backup das configs atuais em $BACKUP"
mkdir -p "$BACKUP" "$HOME/.config"

for dir in sway waybar wofi kitty alacritty; do
  src="$DOTFILES/.config/$dir"
  [ -d "$src" ] || continue
  [ -e "$HOME/.config/$dir" ] && mv "$HOME/.config/$dir" "$BACKUP/"
  cp -r "$src" "$HOME/.config/$dir"
done

chmod +x "$HOME/.config/sway/scripts/"* "$HOME/.config/waybar/scripts/"*.sh 2>/dev/null || true

mkdir -p "$HOME/.images"
cp -n "$DOTFILES/.images/"* "$HOME/.images/" 2>/dev/null || true

[ -f "$DOTFILES/zsh/.zshrc" ] && echo "Dica: copie zsh/.zshrc para ~/.zshrc se quiser meu zsh."

echo "==> Pronto! Faça logout e entre no Sway."
echo "    Seu backup antigo está em: $BACKUP"
