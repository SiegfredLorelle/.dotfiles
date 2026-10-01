# hypr

Hyprland config (Lua), plus hypridle, hyprlock and hyprpaper. Deploys to `~/.config/hypr`.
Desktop only (Arch).

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `hyprland` (with Lua config support) | `hyprland.lua` | yes |
| `kitty`, `wofi` | terminal and launcher binds | yes |
| `quickshell`, `swaync`, `hypridle`, `hyprpaper`, `hyprlock` | autostart and the lock bind | yes |
| `hyprpolkitagent` | polkit prompts (user service started at login) | yes |
| `xdg-desktop-portal-hyprland`, `xdg-desktop-portal-gtk` | screen sharing, file pickers | yes |
| `wireplumber` (`wpctl`) | volume keys | yes |
| `playerctl` | media keys | optional |
| `brightnessctl` | brightness keys | optional (laptops) |
| `hyprshot`, `swappy` | screenshot binds | optional |
| `hyprpicker` | color picker bind | optional |
| `dolphin`, `archlinux-xdg-menu` | file manager and its "Open with" menu | optional |
| `gnome-keyring` | secrets daemon | optional |
| `qt6ct`, `adw-gtk3` | Qt and GTK dark theming | optional |

## Install

```bash
sudo pacman -S --needed hyprland kitty wofi swaync hypridle hyprpaper hyprlock \
    hyprpolkitagent xdg-desktop-portal-hyprland xdg-desktop-portal-gtk wireplumber \
    playerctl brightnessctl hyprshot swappy hyprpicker dolphin archlinux-xdg-menu \
    gnome-keyring qt6ct adw-gtk-theme
```
Quickshell has its own setup, covered in the [quickshell package](../quickshell/README.md).

## After `stow hypr`

1. Stow `wallpapers` too, because `hyprpaper.conf` loads a wallpaper from `~/Pictures/assets/wallpapers`.
2. Log in to Hyprland and run `hyprctl configerrors`. It should print nothing.
