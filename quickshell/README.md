# quickshell

Quickshell bar and widgets (QML). Deploys to `~/.config/quickshell`. Desktop only (Arch).
Development notes are in [`.config/quickshell/CLAUDE.md`](.config/quickshell/CLAUDE.md).

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `quickshell` | the shell | yes |
| `qt6-5compat` | `Qt5Compat.GraphicalEffects` (QML fails to load without it) | yes |
| `qt6-declarative` | `Qt.labs.folderlistmodel` | yes |
| JetBrainsMono Nerd Font | `Theme.primaryFont` | yes |
| Material Symbols Rounded | `Theme.iconFont` | yes |
| `wpctl` (wireplumber) | audio widget | yes |
| `hyprland`, `hyprlock`, `systemd` | workspaces and the power menu | yes |
| `python3`, `curl`, `xdg-open` | Arch news widget | optional |
| An icon theme (e.g. papirus) | app and tray icons, which fall back when missing | optional |

## Install

```bash
sudo pacman -S --needed quickshell qt6-5compat qt6-declarative ttf-jetbrains-mono-nerd \
    wireplumber python curl xdg-utils papirus-icon-theme
yay -S ttf-material-symbols-variable-git   # AUR, or any build of Material Symbols Rounded
```

## After `stow quickshell`

1. Stow `wallpapers` too, because the custom app icons are read from `~/Pictures/assets/icons/apps`.
2. Hyprland starts quickshell at login. To restart it by hand, run `pkill quickshell && quickshell &`.

## Gotchas

- `Bar/components/Performance/SystemStats.qml` hardcodes `hwmon3` (CPU temp), `hwmon2`
  (GPU temp) and `drm/card1` (GPU busy). These indices change between machines, so
  check `/sys/class/hwmon/*/name` and update them.
