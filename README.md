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

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3fb39b20-062e-4a87-8f72-f42fdf201b5a" />
<img width="1920" height="1063" alt="image" src="https://github.com/user-attachments/assets/443acd94-fa54-4a84-9e41-90a6d25c2ac0" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/098f3023-1d4f-43ab-9018-ff715e7abc23" />

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
