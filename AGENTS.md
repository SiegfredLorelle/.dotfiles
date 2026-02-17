# AGENTS.md - Coding Agent Instructions

This repository contains dotfiles for an Arch Linux environment managed with GNU Stow.
Configurations deploy to `~/.config` and the home directory.
These instructions are for AI agents (and humans) to ensure consistency and safety.

## 1. Repository Structure & Navigation

The repository structure maps directly to the target `$HOME` layout.

```text
.dotfiles/
├── .config/
│   ├── hypr/          # Hyprland window manager (Hyprlang)
│   ├── nvim/          # Neovim configuration (Lua)
│   ├── tmux/          # Tmux terminal multiplexer (Conf)
│   ├── quickshell/    # Desktop widgets/bars (QML/QtQuick)
│   ├── kitty/         # Terminal emulator
│   └── wofi/          # Application launcher (CSS)
├── Pictures/assets/   # Wallpapers and icons
├── .zshrc             # Zsh shell configuration
└── .gitconfig         # Git configuration
```

**Agent Note**: Always use absolute paths. The root is `/home/asdasd/.dotfiles`.

## 2. Build, Lint, and Test Commands

Since this is a configuration repository, "building" implies deployment and "testing" implies validation.

### Deployment (GNU Stow)
**CRITICAL**: Always perform a dry-run before deploying changes to verify path mapping.
```bash
# 1. Dry run (Safety Check)
stow -nv .

# 2. Deploy (Symlink files)
stow .

# 3. Clean/Undeploy (Remove symlinks)
stow -D .
```

### Verification & Linting
Run these commands to verify the integrity of specific configurations.

#### Neovim (Lua)
- **Sanity Check**: Verify Neovim starts without error.
  ```bash
  nvim --headless -c 'q'
  ```
- **Lint/Format**: Use `stylua` if available.
  ```bash
  stylua --check .config/nvim/
  ```
- **Test Single File**: Open the file and source it.
  ```vim
  :luafile %
  ```

#### Quickshell (QML)
- **Lint Single File**:
  ```bash
  qmllint .config/quickshell/path/to/file.qml
  ```
- **Run/Test**: Restart the process to see changes.
  ```bash
  pkill quickshell && quickshell &
  ```

#### Shell Scripts (Zsh/Bash)
- **Lint**:
  ```bash
  shellcheck path/to/script.sh
  ```

#### Hyprland
- **Validate**:
  ```bash
  hyprctl config # check for errors
  ```

## 3. Code Style Guidelines

### Lua (Neovim)
- **Formatting**: 4 spaces for options, 2 spaces for plugin tables/deep nesting.
- **Strings**: Double quotes `"` preferred over single quotes.
- **Error Handling**: Use `pcall` for requiring modules that might be missing.
- **Plugin Spec**: Lazy.nvim specs must return a table.
  ```lua
  return {
      "username/repo",
      dependencies = { "dep/repo" },
      event = "VeryLazy",
      config = function()
          require("plugin_name").setup({
              -- Options here
              option = true,
          })
      end,
  }
  ```

### QML (Quickshell/QtQuick)
- **Formatting**: 4 space indentation.
- **Imports**: Order: `Quickshell` -> `QtQuick` -> Local Components -> Theme.
- **Ids**: `camelCase`. Root element usually doesn't need an id unless referenced.
- **Properties**: Custom properties at the top of the object.
- **Signal Handlers**: Explicitly defined.
  ```qml
  import Quickshell
  import QtQuick
  import "root:/Theme"

  Rectangle {
      id: rootItem
      width: 100; height: 100
      color: Theme.backgroundColor

      MouseArea {
          anchors.fill: parent
          onClicked: console.log("Clicked")
      }
  }
  ```

#### Quickshell Patterns & Best Practices

Reference repositories:
- [caelestia-dots/shell](https://github.com/caelestia-dots/shell)
- [end-4/dots-hyprland](https://github.com/end-4/dots-hyprland)

**Creating Singleton Services:**
- Use `pragma Singleton` at file top (no qmldir file needed in Quickshell)
- Use `Singleton` type from Quickshell as root element
- Example:
  ```qml
  pragma Singleton
  import Quickshell
  
  Singleton {
      id: root
      // properties and functions
  }
  ```

**Data Collection:**
- **FileView** for reading files (`/proc/stat`, `/proc/meminfo`, `/sys/*`):
  ```qml
  import Quickshell.Io
  
  FileView {
      id: cpuFile
      path: "/proc/stat"
  }
  // Access with cpuFile.text() and cpuFile.reload()
  ```
- **Process + StdioCollector** for command output:
  ```qml
  Process {
      command: ["cat", "/some/path"]
      stdout: StdioCollector {
          onStreamFinished: {
              const data = this.text.trim()
              // parse data
          }
      }
  }
  ```
- **Never use** `stdout` as direct string property - use StdioCollector or SplitParser

**Timer for Polling:**
- Use Timer with `repeat: true` and `triggeredOnStart: true` for immediate first update
- Typical interval: 1000ms for system stats

### Hyprlang (Hyprland Config)
- **Variables**: `$camelCase`.
- **Monitors/Workspaces**: Define generic rules first, then specific.
- **Indentation**: 4 spaces inside blocks (e.g., `input { ... }`).
  ```hyprlang
  $mainMod = SUPER
  
  general {
      gaps_in = 5
      gaps_out = 20
  }
  
  bind = $mainMod, Q, exec, kitty
  ```

## 4. Naming Conventions

| Context | Style | Example |
|---------|-------|---------|
| **Lua Files** | snake_case | `keymaps.lua`, `lsp_config.lua` |
| **Lua Variables** | snake_case | `local local_var = 1` |
| **QML Files** | PascalCase | `ClockWidget.qml` |
| **QML Components**| PascalCase | `Rectangle`, `Scope` |
| **QML Props/Ids** | camelCase | `backgroundColor`, `mainRect` |
| **Shell Vars** | SCREAMING | `XDG_CONFIG_HOME` |
| **Hyprland Vars** | $camelCase | `$mainMod`, `$terminalApp` |

## 5. Agent Operational Protocol

### Phase 1: Analyze
1. **Read `AGENTS.md`**: You are reading it now.
2. **Explore**: Use `ls -R` or `find` to locate relevant config files.
3. **Context**: Read surrounding files to understand specific plugin configurations or theme variables (especially `.config/quickshell/Theme/Theme.qml`).

### Phase 2: Implementation
1. **Backups**: Do not create `.bak` files. Rely on `git` for version control.
2. **Editing**: Maintain existing comments. Do not remove "magic comments" (like vim fold markers).
3. **Dependencies**:
   - For **Neovim**: Do not manually edit `lazy-lock.json`.
   - For **System**: Assume standard Arch Linux packages (pacman).

### Phase 3: Verification
1. **Syntax Check**: Run the linter commands listed in Section 2.
2. **Visual Check**: For UI (QML/Hyprland), ask the user to verify visual changes if you cannot run the tool.
3. **Git**: Stage only the intended files. Do not stage `lazy-lock.json` unless explicitly updating plugins.

### 5.4 Git Workflow

**Commit Message Convention**
When suggesting commit messages, follow the existing convention from `git log`:

| Scope | Used For | Example |
|-------|----------|---------|
| `quickshell(bar):` | Bar/widget changes | `quickshell(bar): add AudioService singleton` |
| `hyprland:` | Hyprland config | `hyprland: fix pavucontrol not following theme` |
| `neovim:` | Neovim config | `neovim: add lsp configuration` |
| `kitty:` | Kitty terminal config | `kitty: update font settings` |
| `zsh:` | Zsh shell config | `zsh: add bun autocompletes` |
| `opencode:` | Opencode config | `opencode: add superpowers documentation` |
| `chore:` | Maintenance tasks | `chore: ignore markdown and cache files` |

**Rules:**
- Use lowercase, present tense, descriptive messages
- Check `git log` to understand the convention for the specific file being changed
- Match the scope to the configuration area being modified

**Agent Restrictions**
**CRITICAL**: AI agents MUST NOT run `git commit` commands.
- **DO**: Stage files with `git add`
- **DO**: Suggest commit messages based on `git log` patterns
- **DO**: Use `git status` and `git diff` to understand changes
- **NEVER**: Run `git commit`
- **NEVER**: Run `git push`

Always leave committing to the user. Present staged changes and suggest an appropriate commit message, but let the user execute the actual commit.

## 6. Color Palette & Theme (OneDark-ish)

Reference these colors when creating new UI elements to maintain consistency.

| Color Name | Hex Code | Semantic Usage |
|------------|----------|----------------|
| **Background**| `#282C34` | Main window background |
| **Foreground**| `#cdd6f4` | Primary text |
| **Red**       | `#e06c75` | Errors, deletions, close buttons |
| **Green**     | `#98c379` | Success, additions, git diffs |
| **Yellow**    | `#e5c07b` | Warnings, changed states |
| **Blue**      | `#61afef` | Information, focused elements |
| **Purple**    | `#c678dd` | Keywords, special highlighting |
| **Cyan**      | `#56b6c2` | Operators, accents |

---
*Generated for agentic coding context.*
