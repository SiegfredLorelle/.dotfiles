# claude

Claude Code user config. Deploys to:

- `~/.claude/settings.json`: user settings
- `~/.claude/statusline.sh`: status line showing the model, the current context size in
  tokens (`152k`) and plan usage (`5h 34% · 7d 12%`, subscription logins only).
- `~/.claude/CLAUDE.md`: global instructions (Karpathy's four principles)
- `~/.claude/skills/<name>/`: personal skills, copied verbatim from upstream. See
  `.claude/skills/VENDORED.md` for sources, pinned commits and how to check for drift.

Dependencies: the `claude` CLI, and Node.js (`pacman -S nodejs`) for the `security-audit`
skill's validator scripts, and `jq` (`pacman -S jq`) for `statusline.sh`. The settings
don't use any hooks.

Create `~/.claude/skills/` before stowing. If it's missing, stow links the whole
directory, and the skills Claude Code syncs from your account land inside this repo.

After adding or renaming a skill, run `stow -R claude` to refresh the links.
