# waybar

Waybar config. Deploys to `~/.config/waybar`. **Not used right now:** Quickshell is the
bar, and Hyprland doesn't start waybar.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `waybar` | the bar | yes |
| Nerd Font | module icons | yes |
| `mpd`, `power-profiles-daemon`, `pavucontrol` | matching modules and on-click actions | optional |

## Gotchas

- The config references `~/.config/waybar/mediaplayer.py` and `power_menu.xml`, but
  neither file is in the repo, so those modules stay broken until you add them.
- The `sway/language` module only works on sway.
