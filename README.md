# Sway dotfiles (SwayFX + Waybar + Kitty + Wofi) — Arch Linux

![preview](preview.png)
![preview 2](preview-2.png)

Meu setup de Sway com efeitos do **SwayFX** (blur, cantos arredondados).

## Componentes

- WM: SwayFX
- Barra: Waybar
- Terminal: Kitty
- Launcher: Wofi
- Ícones: Papirus-Dark
- Shell: zsh

## Instalação

```bash
git clone https://github.com/kravuhas/I3_sway_dotfiles_archlinux.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

O script faz backup das suas configs antigas antes de sobrescrever.

## Antes de usar, ajuste

- **Monitor:** em `~/.config/sway/config` há `output DP-1 resolution 1920x1080@144Hz`. Troque pelo seu monitor (veja com `swaymsg -t get_outputs`).
- **Teclado:** em `~/.config/sway/config.d/input` o layout está configurado para o meu teclado.
- **VNC:** o script `vnc_server.sh` abre o `wayvnc` na rede. Só use se entender o risco.

## Créditos

Baseado nos dotfiles de [SocketByte](https://github.com/SocketByte/dotfiles).
