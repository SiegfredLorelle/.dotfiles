# herdr

herdr (terminal workspace manager) config, ported from the tmux package. Deploys to
`~/.config/herdr/config.toml`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `herdr` | reads `~/.config/herdr/config.toml` | yes |

## Install

See https://herdr.dev. The binary lives in `~/.local/bin/herdr`, and `herdr update` keeps it current.

## After `stow herdr`

1. herdr writes its own `config.toml` the first time it runs. If that file already exists,
   stow reports a conflict. Delete the file, then stow again.
2. Apply the config: `herdr server reload-config` (or press `prefix+r`).

## Verify

```bash
herdr config check    # prints "config: ok"
```

## Differences from tmux

- Pane focus is `prefix+h/j/k/l`, not a direct `Ctrl+h/j/k/l`. herdr has no
  vim-tmux-navigator, so Neovim keeps `Ctrl+h/j/k/l` for its own splits.
- There's no vi copy mode. `prefix+e` opens the scrollback in `$EDITOR`, and selecting
  with the mouse copies.
- `prefix+r` reloads the config. Resize mode moves to `prefix+Shift+r`.
- herdr keeps sessions alive in its server process, so it doesn't need resurrect or
  continuum. `pane_history` saves scrollback across server restarts.
- `~/.config/herdr/` also holds sockets, logs and `session.json`. Stow links only
  `config.toml`.
