# AGENTS.md

The full coding-agent instructions for this repository live in **[CLAUDE.md](./CLAUDE.md)**
— the single source of truth. They are kept there because Claude Code is the primary tool
used in this repo and auto-loads `CLAUDE.md`.

**Read [CLAUDE.md](./CLAUDE.md) before making changes.** Everything in it applies to all
agents (OpenCode, Codex, etc.), not just Claude Code — repository structure, build/lint/test
commands, code style (Lua / QML / Hyprlang), naming conventions, the agent operational
protocol, git workflow, and the theme color palette.

## Critical rule

AI agents **MUST NOT** run `git commit` or `git push`. Stage with `git add`, suggest a
commit message following the `scope:` convention in `git log`, and leave the commit to the
user. (Full details in [CLAUDE.md](./CLAUDE.md) §5.4.)
