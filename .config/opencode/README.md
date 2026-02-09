# Superpowers for OpenCode

Superpowers is an agentic skills framework for OpenCode that provides structured workflows for software development. It's **NOT included** in this dotfiles repo to keep the repository lightweight - it's installed separately as an external dependency.

## Prerequisites

- [OpenCode.ai](https://opencode.ai) installed
- Git installed

## Installation

After setting up your dotfiles, install superpowers:

### Option 1: Manual Installation

```bash
# Clone superpowers repository
git clone https://github.com/obra/superpowers.git ~/.config/opencode/superpowers

# Create necessary directories
mkdir -p ~/.config/opencode/plugins ~/.config/opencode/skills

# Create symlinks
ln -s ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js ~/.config/opencode/plugins/superpowers.js
ln -s ~/.config/opencode/superpowers/skills ~/.config/opencode/skills/superpowers

# Restart OpenCode
# The plugin will automatically load on next start
```

### Option 2: Using the Install Script

```bash
bash ~/.dotfiles/.config/opencode/scripts/install-superpowers.sh
```

## Verification

Check that symlinks were created correctly:

```bash
ls -l ~/.config/opencode/plugins/superpowers.js
ls -l ~/.config/opencode/skills/superpowers
```

Both should show symlinks pointing to the superpowers directory.

Test by asking OpenCode: "do you have superpowers?"

## Usage

### Finding Skills

Use OpenCode's native `skill` tool to list available skills:

```
use skill tool to list skills
```

### Loading a Skill

Use OpenCode's native `skill` tool to load a specific skill:

```
use skill tool to load superpowers/brainstorming
```

### Personal Skills

Create your own skills in `~/.config/opencode/skills/`:

```bash
mkdir -p ~/.config/opencode/skills/my-skill
```

Create `~/.config/opencode/skills/my-skill/SKILL.md`:

```markdown
---
name: my-skill
description: Use when [condition] - [what it does]
---

# My Skill

[Your skill content here]
```

### Project Skills

Create project-specific skills in `.opencode/skills/` within your project.

**Skill Priority:** Project skills > Personal skills > Superpowers skills

## Updating

Superpowers updates independently of dotfiles. To update to the latest version:

```bash
cd ~/.config/opencode/superpowers
git pull
```

Then restart OpenCode to load the updates.

**Note:** The symlinks in `~/.config/opencode/plugins/` and `~/.config/opencode/skills/` will automatically reference the updated version.

## Uninstalling

To remove superpowers:

```bash
rm -f ~/.config/opencode/plugins/superpowers.js
rm -rf ~/.config/opencode/skills/superpowers
rm -rf ~/.config/opencode/superpowers
```

## Troubleshooting

### Plugin not loading

1. Check that symlinks exist and point to correct locations:
   ```bash
   ls -l ~/.config/opencode/plugins/superpowers.js
   ls ~/.config/opencode/superpowers/.opencode/plugins/superpowers.js
   ```
2. Check OpenCode logs for errors
3. Restart OpenCode

### Skills not found

1. Check skills symlink: `ls -l ~/.config/opencode/skills/superpowers`
2. Verify it points to: `~/.config/opencode/superpowers/skills`
3. Use `skill` tool to list what's discovered

### Tool mapping

When skills reference Claude Code tools:
- `TodoWrite` → `update_plan`
- `Task` with subagents → `@mention` syntax
- `Skill` tool → OpenCode's native `skill` tool
- File operations → your native tools

## Getting Help

- Report issues: https://github.com/obra/superpowers/issues
- Full documentation: https://github.com/obra/superpowers/blob/main/docs/README.opencode.md
