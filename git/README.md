# git

Global git config. Deploys to `~/.gitconfig`.

## Dependencies

| Tool | Needed for | Required? |
|------|------------|-----------|
| `git` | everything | yes |
| `nvim` | `core.editor` (see the [nvim package](../nvim/README.md)) | yes |

## After `stow git`

- Check that `user.name` and `user.email` are right for this machine.
- `.gitconfig.local` is gitignored but **not** included automatically. To use it for
  machine-specific or sensitive settings, add `[include] path = ~/.gitconfig.local`.
