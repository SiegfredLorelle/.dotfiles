# herdr-app

Herdr desktop app (`herdr-app`) keybindings and mods. Deploys into `~/.config/herdr-app`.
The terminal version of herdr is configured in the separate `herdr` package.

Only `keys.json`, `layouts/tmux.json`, `themes/tmux.json` and `mods/{prefix,picker-vim,tmux-status,copy-mode}/` are tracked. The app writes everything else in
`~/.config/herdr-app/` itself, including layouts, state, sockets, and the shipped mods.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `herdr-app` + `herdr-core` | reads `~/.config/herdr-app` | yes |
| `nvim` with `clipboard=unnamedplus`, `wl-copy` | copy mode (`Ctrl+b [`) yanks to the system clipboard | yes |
| JetBrainsMono Nerd Font | `tmux-status` footer text and icons | yes |

Install the font before you use the `tmux` layout. Otherwise the footer falls back to
the system font. Restart the app after you install it.

- Arch: `sudo pacman -S ttf-jetbrains-mono-nerd`
- macOS: `brew install --cask font-jetbrains-mono-nerd-font`

## Install

See https://herdr.dev. The binaries live in `~/.local/bin`.

## After `stow herdr-app`

1. The app creates its own `keys.json` the first time it runs. If that file already
   exists, stow reports a conflict. Delete the app's file, then stow again.
2. You don't need to restart. The app reloads keys and mods while it runs.
3. Switch to the tmux layout with `herdr-app do layout.switch --name tmux`, or cycle
   layouts with `Ctrl+Shift+L`.

## `keys.json` on Linux and macOS

`keys.json` has no per-OS sections, so one file holds both sets: Linux uses the
`ctrl`/`alt` binds, macOS the stock `cmd` binds. The other OS's set doesn't get in
the way. Option types characters on macOS, and on Linux `cmd` means Super, which
Hyprland takes first for its own binds. `Ctrl+1-9` selects tabs on both, so macOS
spaces moved to `Cmd+Option+1-9`. In a terminal, `Alt+←/→` jump by word, which
overrides the Linux pane binds there (`Alt+h/l` still move between panes).

## The `tmux` layout

This is a copy of the app's `main` layout with two changes. The top tab bar is removed,
and the footer is the `tmux-status` mod, which copies the tmux status line: the space
name, tabs with program icons (the active tab is magenta), and the hostname. Its colors
come from `tmux/.config/tmux/tmux.conf`, so change them in both places. The icons are
herdr's own program icons (the ones the sidebar shows), not `get-window-icon.sh`'s Nerd
Font glyphs. The footer needs JetBrainsMono Nerd Font.

The layout uses `themes/tmux.json`. The theme shares its name with the layout, so it
belongs to that layout and doesn't show up for other layouts. It sets the terminals,
sidebar and borders to the same One Dark colors as the footer. Picking a theme in the
app overrides it. To get it back, set `"theme": "tmux"` on the layout root again.

Removing the top bar also removes the Files/Changes panel buttons and the window
buttons. `Ctrl+b f` and `Ctrl+b g` open or close the Files and Changes panels instead.

## Verify

```bash
herdr-app check ~/.config/herdr-app/mods/prefix   # "check passed"
herdr-app status                                   # "errors": []
```

## The `Ctrl+b` prefix

The app has no prefix keys, so `mods/prefix` adds one. `Ctrl+b` opens a small popup.
The next key you press runs a command (tmux keys first, then the herdr terminal app's
keys), and Esc cancels. The key map is `ACTIONS` in `mods/prefix/main.js`.

## Copy mode (`Ctrl+b [`)

herdr has no copy mode, so `mods/copy-mode` imitates tmux's. It writes the focused
terminal's screen and up to 10,000 lines of scrollback to
`~/.cache/herdr-copy-mode/<terminal>.txt` and opens that file in Neovim in a new
`copy` tab. Use vim motions and `y` to copy. `q`, `Esc` or `:q` closes the tab and
returns you to the tab you started from. `Ctrl+b /` searches in place instead.

It opens a tab rather than a popup because herdr can't give the keyboard to a terminal
inside a dialog. The first read of an idle agent's history takes about 3 seconds.

While an agent is working, `hc read` returns only its screen, not its history, and
ends the file with an `[hc]` note saying so. Wait until the agent stops if you need
the scrollback.

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
