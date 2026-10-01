# zsh

Zsh config with no plugin manager. Deploys to `~/.zshrc`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `zsh` | the shell | yes |
| `pyenv` | `~/.pyenv` block | optional, skipped when absent |
| `bun` | `~/.bun` block + completions | optional, skipped when absent |
| JDK 17 / Android SDK | `~/.jdks/...` block | optional, skipped when absent |

## Install

```bash
sudo pacman -S --needed zsh     # Arch
sudo apt install zsh            # Debian / Ubuntu
sudo dnf install zsh            # Fedora
```

## After `stow zsh`

1. Make zsh the login shell, then log out and back in:
   ```bash
   chsh -s "$(command -v zsh)"
   ```

## Gotchas

- If a `~/.zshrc` already exists, stow won't overwrite it. Move the old file out of the
  way first (or use `stow --adopt` and review the diff).
