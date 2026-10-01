# theme

KDE/Qt color settings (`kdeglobals`) and the xdg-desktop-portal backend config. Deploys
to `~/.config`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `xdg-desktop-portal-hyprland`, `xdg-desktop-portal-gtk` | portal backends (`default=hyprland;gtk`) | yes |
| `kvantum` + a Kvantum theme | `ColorScheme=kvantum-dark` for Qt/KDE apps | optional |

## Gotchas

- The portal file is named `hpyrland-portals.conf`. xdg-desktop-portal only reads
  `hyprland-portals.conf` (or `portals.conf`), so this file is currently ignored.
