# mimeapps

Default applications (`mimeapps.list`): which app opens folders, images, PDFs and links.
Deploys to `~/.config`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `nautilus` | folders | optional |
| `swappy` | PNG images | optional |
| `zen-browser` (AUR) | web links, HTML, PDF | optional |

## Gotchas

- `xdg-mime default`, browsers' "set as default" and GTK "Open with" write the file
  atomically, which **replaces the stow symlink with a regular file**. When that happens,
  pull the change back into the repo and relink:
  ```bash
  cd ~/.dotfiles && stow --adopt mimeapps && git diff mimeapps/
  ```
  Use `git diff` to keep only the defaults you want; apps also add per-machine handlers here.
