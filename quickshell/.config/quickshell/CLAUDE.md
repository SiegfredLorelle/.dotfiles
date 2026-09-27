# CLAUDE.md — Quickshell

Guidance for working inside `.config/quickshell/` (QML/QtQuick desktop bar and
widgets). Loaded in addition to the repository-root [`CLAUDE.md`](../../CLAUDE.md),
which remains the source of truth for repo-wide rules (structure, Stow
build/lint/test, naming, git workflow). The general QML code-style block lives in
root §3; this file holds the Quickshell-specific patterns and theming guidance.

## Theme & Design — source of truth

**`Theme/Theme.qml` is the single source of truth for every color, font, and
spacing value.** It is a `pragma Singleton`; import it and reference its
properties — **never hardcode hex values, font names, or pixel sizes** in
components. The palette is teal/gold (not OneDark). Read `Theme.qml` for current
values before styling anything.

```qml
import "root:/Theme"

Rectangle {
    color: Theme.secondaryColor
    radius: Theme.borderRadius
}
```

**Semantic usage** (names defined in `Theme.qml`):

- **`primaryColor`** (gold) — primary accents, highlights, focused/active state.
- **`secondaryColor`** (teal) — backgrounds, surfaces, default chrome.
- **Variant scheme** — each base color has graded shades and translucent forms:
  - `*LightColor` / `*LighterColor` — progressively lighter shades (hover,
    raised surfaces, subtle emphasis).
  - `*Opaqued` suffix — the same color at ~38% alpha (`#60…`), for overlays,
    glows, and translucent fills. Pair the matching base + `Opaqued` variant.
- **Fonts** — `primaryFont` for text; `iconFont` (+ `iconStyle` / `iconFontStyle`)
  for Material Symbols icons.
- **Sizes** — `normalFontSize` / `mediumFontSize` / `largeFontSize` / `iconSize`.
- **Spacing & dimensions** — `smallSpacing` / `normalSpacing` / `largeSpacing`,
  `borderRadius`, `barGap`. Use these tokens instead of literal numbers so the
  layout stays consistent and themeable.

If a needed value doesn't exist, add a `readonly property` to `Theme.qml` rather
than hardcoding it at the call site.

## Quickshell Patterns & Best Practices

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

## Verification

- Lint a single file: `qmllint .config/quickshell/path/to/file.qml`
- Run/test: `pkill quickshell && quickshell &`
