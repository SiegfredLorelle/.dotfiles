// System Tray singleton service
// Primary: Quickshell.Services.SystemTray (D-Bus StatusNotifierItem)
// Fallback: pgrep-based process watchlist for daemons without tray icons

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import Quickshell.Services.SystemTray

Singleton {
    id: root

    // Tray items from D-Bus (event-driven, no polling)
    readonly property list<var> trayItems: SystemTray.items.values

    // Fallback process watchlist for daemons without tray icons.
    // `icon` is a base filename resolved against AppIconCache (a file dropped in
    // ~/Pictures/assets/icons/apps, e.g. docker.png).
    readonly property list<var> watchlist: [
        { name: "dockerd",      displayName: "Docker",     icon: "docker" },
        { name: "syncthing",    displayName: "Syncthing",  icon: "syncthing", windowTitle: "Syncthing", launchCommand: ["xdg-open", "http://127.0.0.1:8384"] },
    ]

    // Overrides for SNI apps whose tray id can't reach the Hyprland window class
    // by normalization/last-segment rules (e.g. OBS reports id "obs" but the
    // window class is "com.obsproject.studio"). Keyed by normalized tray id.
    readonly property var trayClassAliases: ({ "obs": "com.obsproject.studio" })

    // Fallback results: [{name, displayName, icon, windowClass, windowTitle, launchCommand, running}]
    property list<var> fallbackItems: []

    readonly property list<var> runningFallbackItems: fallbackItems.filter(item => item.running)

    Timer {
        id: fallbackTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.pollFallbackProcesses()
    }

    Process {
        id: pgrepProcess
        stdout: StdioCollector {
            id: pgrepOutput
            onStreamFinished: root.processPgrepOutput()
        }
    }

    Process {
        id: launchProcess
    }

    function pollFallbackProcesses() {
        const patterns = []
        for (let i = 0; i < watchlist.length; i++) {
            patterns.push(watchlist[i].name)
        }
        pgrepProcess.command = ["pgrep", "-xl", patterns.join("|")]
        pgrepProcess.running = true
    }

    function processPgrepOutput() {
        const text = pgrepOutput.text.trim()
        const lines = text.length > 0 ? text.split("\n") : []
        const results = []
        for (let i = 0; i < watchlist.length; i++) {
            const entry = watchlist[i]
            const running = lines.some(line => line.indexOf(entry.name) !== -1)
            results.push({
                name: entry.name,
                displayName: entry.displayName,
                icon: entry.icon,
                windowClass: entry.windowClass || "",
                windowTitle: entry.windowTitle || "",
                launchCommand: entry.launchCommand || [],
                running: running
            })
        }
        fallbackItems = results
    }

    // Fallback icon click: focus the app's existing window if there is one;
    // otherwise, for launch-type entries (e.g. Syncthing's web UI), open it and
    // bring the browser forward once its title updates. Focus-first avoids
    // spawning a new tab on every click.
    function activateFallback(entry) {
        // Ignore repeat clicks while a launch+retry is already in flight so
        // rapid presses can't stack up multiple launches.
        if (root.pendingFocus) {
            return
        }

        if (root.focusToplevel([entry.windowClass], [entry.windowTitle])) {
            return
        }

        const command = entry.launchCommand || []
        if (command.length === 0) {
            return
        }

        launchProcess.command = command
        launchProcess.running = true
        root.startFocusRetry([entry.windowClass], [entry.windowTitle])
    }

    // Leading alphanumeric run of a tray id, dropping suffixes SNI apps append
    // (e.g. "discord_status_icon_1" -> "discord", "vlc" -> "vlc").
    function normalizeTrayId(id) {
        const m = (id || "").toLowerCase().match(/^[a-z0-9]+/)
        return m ? m[0] : ""
    }

    // Candidate window classes for an SNI item: raw id, normalized id, and any
    // configured alias for the normalized id.
    function trayClasses(item) {
        const raw = (item.id || "").toLowerCase()
        const base = root.normalizeTrayId(raw)
        const out = [raw, base]
        const alias = root.trayClassAliases[base]
        if (alias)
            out.push(alias)
        return out
    }

    // SNI tray icon click: focus the app's window if one exists. Class-only
    // matching (title matching is too loose for SNI, e.g. "obs" hits Obsidian).
    // Returns false when no window matches, so the caller runs modelData.activate().
    function focusTrayItem(item) {
        return root.focusToplevel(root.trayClasses(item), [])
    }

    // Reverse-DNS last segment of a class ("com.obsproject.studio" -> "studio",
    // "md.obsidian" -> "obsidian"), so an app whose id equals that segment matches.
    function classLastSegment(cls) {
        const parts = cls.split(".")
        return parts[parts.length - 1]
    }

    // Scan open windows for one matching any class (equality on class /
    // initialClass / their reverse-DNS last segment) or any title (case-insensitive
    // substring). Returns the ipc object or null.
    function findToplevel(classes, titles) {
        const wantClasses = (classes || []).filter(c => c).map(c => c.toLowerCase())
        const wantTitles = (titles || []).filter(t => t).map(t => t.toLowerCase())
        if (wantClasses.length === 0 && wantTitles.length === 0) {
            return null
        }

        const toplevels = Hyprland.toplevels.values
        for (let i = 0; i < toplevels.length; i++) {
            const ipc = toplevels[i].lastIpcObject || {}
            const cls = (ipc.class || "").toLowerCase()
            const initialCls = (ipc.initialClass || "").toLowerCase()
            const title = (ipc.title || "").toLowerCase()
            const initialTitle = (ipc.initialTitle || "").toLowerCase()
            const classHit = wantClasses.some(c =>
                c === cls || c === initialCls
                || c === root.classLastSegment(cls) || c === root.classLastSegment(initialCls))
            if (classHit)
                return ipc
            if (wantTitles.some(t => title.indexOf(t) !== -1 || initialTitle.indexOf(t) !== -1))
                return ipc
        }
        return null
    }

    // Focus the matched window precisely by address. Returns true if focused.
    function focusToplevel(classes, titles) {
        Hyprland.refreshToplevels()
        const ipc = root.findToplevel(classes, titles)
        if (!ipc || !ipc.address) {
            return false
        }
        Hyprland.dispatch('hl.dsp.focus({ window = "address:' + ipc.address + '" })')
        return true
    }

    // A launched web UI needs a moment to open its tab and update the window
    // title before we can match it, so poll a few times after launching.
    property var pendingFocus: null

    function startFocusRetry(classes, titles) {
        root.pendingFocus = { classes: classes, titles: titles, attempts: 0 }
        focusRetryTimer.restart()
    }

    Timer {
        id: focusRetryTimer
        interval: 250
        repeat: true
        onTriggered: {
            const pending = root.pendingFocus
            if (!pending || pending.attempts >= 6) {
                root.pendingFocus = null
                stop()
                return
            }
            pending.attempts++
            if (root.focusToplevel(pending.classes, pending.titles)) {
                root.pendingFocus = null
                stop()
            }
        }
    }
}
