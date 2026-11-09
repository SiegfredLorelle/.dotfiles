# herdr-app

Herdr desktop app (`herdr-app`) keybindings and mods. Deploys into `~/.config/herdr-app`.
The terminal version of herdr is configured in the separate `herdr` package.

Only `keys.json`, `layouts/tmux.json` and `mods/{prefix,picker-vim,tmux-status}/` are tracked. The app writes everything else in
`~/.config/herdr-app/` itself, including layouts, state, sockets, and the shipped mods.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `herdr-app` + `herdr-core` | reads `~/.config/herdr-app` | yes |

## Install

See https://herdr.dev. The binaries live in `~/.local/bin`.

## After `stow herdr-app`

1. The app creates its own `keys.json` the first time it runs. If that file already
   exists, stow reports a conflict. Delete the app's file, then stow again.
2. You don't need to restart. The app reloads keys and mods while it runs.
3. Switch to the tmux layout with `herdr-app do layout.switch --name tmux`, or cycle
   layouts with `Ctrl+Shift+L`.

## The `tmux` layout

This is a copy of the app's `main` layout with two changes. The top tab bar is removed,
and the footer is the `tmux-status` mod, which copies the tmux status line: the space
name, tabs with Nerd Font icons (the active tab is magenta), and the hostname. Its colors
and icon mapping come from `tmux/.config/tmux/tmux.conf` and `get-window-icon.sh`, so
change them in both places. The footer needs JetBrainsMono Nerd Font.

Removing the top bar also removes the Files/Changes panel buttons and the window
buttons. Use the command palette (`Ctrl+Shift+P`) for those.

## Verify

```bash
herdr-app check ~/.config/herdr-app/mods/prefix   # "check passed"
herdr-app status                                   # "errors": []
```

## The `Ctrl+b` prefix

The app has no prefix keys, so `mods/prefix` adds one. `Ctrl+b` opens a small popup.
The next key you press runs a command (tmux keys first, then the herdr terminal app's
keys), and Esc cancels. The key map is `ACTIONS` in `mods/prefix/main.js`.

## `picker-vim`

This is a copy of the app's own `picker` mod with `Ctrl+j`/`Ctrl+k` added for moving
the selection. Plain `j`/`k` stay as text for the filter. `Ctrl+b s` and `Ctrl+b w`
open it. The copy was made from picker 0.1.14 (see `cloned_from` in `mod.json`), so it
won't pick up later changes to the app's picker. To update it, clone the new version and
add the `ctrl+j/k` lines again:

```bash
herdr-app do mod.clone --name picker --as picker-vim-new
```

## Gotchas

- The app doesn't notice changes to mods it reaches through a symlink. After editing
  one here, switch layouts away and back to reload it (`Ctrl+Shift+L`, twice).

- Once `keys.json` has been edited, app updates stop adding new default shortcuts to it.
  Add those yourself; `herdr-app commands` lists them.
- Binding `Ctrl+b` takes it away from the shell (readline's back-one-character).
- `Ctrl+Alt+Shift+Escape` resets the app's keys. It moves `keys.json` aside, which
  removes the symlink. To fix it, delete the `keys.json.reset-*` file and run
  `stow -R herdr-app`.
