# Vendored skills

Copied verbatim from upstream on **2026-11-03**, so changes upstream can be tracked by diffing.
Do not edit these files in place; if you change one, note it under "Local modifications".

## Sources

| Source | Commit | Licence |
|---|---|---|
| [forrestchang/andrej-karpathy-skills](https://github.com/forrestchang/andrej-karpathy-skills) | `2c606141936f1eeef17fa3043a72095b4765b9c2` | no LICENSE file (SKILL.md frontmatter says MIT) |
| [mattpocock/skills](https://github.com/mattpocock/skills) | `4ae2317ddb22b046e26455e4f9c9b3aaaf62212d` | MIT, see `LICENSE-mattpocock` |
| [cursor/plugins](https://github.com/cursor/plugins) (`pstack/`) | `ae5650febf4320793844c12c4adaa937f417f8da` | MIT, see `LICENSE-pstack` |

## Files

| Local path | Upstream repo | Upstream path |
|---|---|---|
| `CLAUDE.md` | andrej-karpathy-skills | `CLAUDE.md` |
| `skills/grill-me/` | mattpocock/skills | `skills/productivity/grill-me/` |
| `skills/grilling/` | mattpocock/skills | `skills/productivity/grilling/` |
| `skills/grill-with-docs/` | mattpocock/skills | `skills/engineering/grill-with-docs/` |
| `skills/domain-modeling/` | mattpocock/skills | `skills/engineering/domain-modeling/` |
| `skills/wayfinder/` | mattpocock/skills | `skills/engineering/wayfinder/` |
| `skills/research/` | mattpocock/skills | `skills/engineering/research/` |
| `skills/prototype/` | mattpocock/skills | `skills/engineering/prototype/` |
| `skills/setup-matt-pocock-skills/` | mattpocock/skills | `skills/engineering/setup-matt-pocock-skills/` |
| `skills/to-spec/` | mattpocock/skills | `skills/engineering/to-spec/` |
| `skills/to-tickets/` | mattpocock/skills | `skills/engineering/to-tickets/` |
| `skills/implement/` | mattpocock/skills | `skills/engineering/implement/` |
| `skills/tdd/` | mattpocock/skills | `skills/engineering/tdd/` |
| `skills/codebase-design/` | mattpocock/skills | `skills/engineering/codebase-design/` |
| `skills/matt-code-review/` | mattpocock/skills | `skills/engineering/code-review/` |
| `skills/handoff/` | mattpocock/skills | `skills/productivity/handoff/` |
| `skills/diagnosing-bugs/` | mattpocock/skills | `skills/engineering/diagnosing-bugs/` |
| `skills/pr/` | mattpocock/skills | `skills/engineering/pr/` |
| `skills/unslop/` | cursor/plugins | `pstack/skills/unslop/` |
| `skills/blast-radius/` | cursor/plugins | `pstack/skills/blast-radius/` |
| `skills/in-your-own-words/` | cursor/plugins | `pstack/skills/in-your-own-words/` |
| `skills/ketchup/` | cursor/plugins | `pstack/skills/ketchup/` |
| `skills/create-verification-skill/` | cursor/plugins | `pstack/skills/create-verification-skill/` |
| `skills/maintain-verification-skill/` | cursor/plugins | `pstack/skills/maintain-verification-skill/` |

## Checking for upstream changes

```bash
T=$(mktemp -d)
git clone -q --depth 1 https://github.com/mattpocock/skills.git "$T/matt"
git clone -q --depth 1 https://github.com/cursor/plugins.git "$T/cursor"
git clone -q --depth 1 https://github.com/forrestchang/andrej-karpathy-skills.git "$T/karpathy"
cd ~/.dotfiles/claude/.claude
diff "$T/karpathy/CLAUDE.md" CLAUDE.md
for d in skills/*/; do
  n=$(basename "$d")
  src=$(ls -d "$T"/matt/skills/*/"$n" "$T/cursor/pstack/skills/$n" 2>/dev/null | head -1)
  [ -n "$src" ] && diff -r "$src" "$d"
done
# Upstream changelogs: git -C "$T/matt" log --oneline 4ae2317..HEAD -- skills/
```

## Not copied (on purpose)

- Pocock `triage`: to-spec/to-tickets only reference its label vocabulary, which `setup-matt-pocock-skills` defines.
- pstack `why`, `how`, `arena`: blast-radius mentions them as optional steps, but they are wired to Cursor (`generalPurpose` subagents, `pstack-models.mdc`, Grok defaults).
- Karpathy `skills/karpathy-guidelines`: same content as its CLAUDE.md.

## Local modifications

- **`code-review` → `matt-code-review`** (2026-11-03). Renamed so it doesn't shadow Claude Code's built-in `/code-review`, which reviews correctness bugs, while this one reviews standards and spec fidelity. Changed:
  - `matt-code-review/SKILL.md`: dir name and frontmatter `name:`
  - `implement/SKILL.md`: `call the Skill tool with "matt-code-review"`
  - `tdd/SKILL.md`: `(see the \`matt-code-review\` skill)`

  When diffing against upstream, compare `matt-code-review/` with upstream `skills/engineering/code-review/` and expect these three lines to differ.
