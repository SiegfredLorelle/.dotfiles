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

## Commit-msg hook (no AI attribution)

`init.templateDir` points at `~/.dotfiles/git/.config/git/template` (the repo copy, not a stowed
link: git copies a symlink as-is, and a relative one breaks inside `.git/hooks`), so every new clone or `git init`
gets `hooks/commit-msg`, which strips Claude `Co-Authored-By:` and `Claude-Session:`
trailers and the "Generated with Claude Code" line. Human co-authors are kept.

- It needs `perl`, and this repo cloned at `~/.dotfiles`.
- `stow git` also links it into `~/.config/git/template/`; that link is unused and harmless.
- Repos that already exist don't get it automatically: run `git init` inside one to copy it in
  (this changes nothing else; an existing `commit-msg` hook is left alone).
- pre-commit's own `commit-msg` install keeps this one as `commit-msg.legacy` and still runs it.
