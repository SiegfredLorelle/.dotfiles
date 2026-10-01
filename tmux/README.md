# tmux

tmux config with TPM plugins. Deploys to `~/.config/tmux`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `tmux` ≥ 3.1 | reads `~/.config/tmux/tmux.conf` | yes |
| `git` | cloning TPM and plugins | yes |
| `bash` | `scripts/get-window-icon.sh` | yes |
| `wl-copy` / `xclip` | tmux-yank copies to the system clipboard | optional (desktop) |
| Nerd Font | status-line glyphs (on the machine running the terminal) | optional |

## Install

```bash
sudo pacman -S --needed tmux git        # Arch
sudo apt install tmux git               # Debian / Ubuntu
sudo dnf install tmux git               # Fedora
```

## After `stow tmux`

1. Clone TPM into the plugin dir that `tmux.conf` loads:
   ```bash
   git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
   ```
2. Start tmux and press `Ctrl+b`, release it, then press `Shift+i`. This config doesn't
   change the prefix, so it's the default `Ctrl+b`, not Super. That installs the plugins:
   sensible, vim-tmux-navigator, yank, resurrect, continuum. Or skip the keybind:
   ```bash
   ~/.config/tmux/plugins/tpm/bin/install_plugins
   ```

## Verify

```bash
ls ~/.config/tmux/plugins    # tpm plus the five plugins
```

## Gotchas

- The path has to be `~/.config/tmux/plugins/tpm`. TPM's own README says
  `~/.tmux/plugins/tpm`, and this config won't find it there.
- The plugin directories are gitignored. Stow links the folder, and TPM fills it in.
