// System Tray singleton service
// Primary: Quickshell.Services.SystemTray (D-Bus StatusNotifierItem)
// Fallback: pgrep-based process watchlist for daemons without tray icons
// Pattern: pragma Singleton + Singleton type

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

    // Fallback process watchlist for daemons without tray icons
    readonly property list<var> watchlist: [
        { name: "dockerd",      displayName: "Docker",     icon: "deployed_code" },
        { name: "syncthing",    displayName: "Syncthing",  icon: "sync", launchCommand: ["xdg-open", "http://127.0.0.1:8384"] },
        { name: "tailscaled",   displayName: "Tailscale",  icon: "lan" },
        { name: "mpd",          displayName: "MPD",        icon: "music_note" },
    ]

    // Fallback results: [{name, displayName, icon, windowClass, launchCommand, running}]
    property list<var> fallbackItems: []

    // Pre-filtered to only running fallback items
    readonly property list<var> runningFallbackItems: fallbackItems.filter(item => item.running)

    // Timer for fallback process polling
    Timer {
        id: fallbackTimer
        interval: 5000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.pollFallbackProcesses()
    }

    // Process for checking running daemons
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
                launchCommand: entry.launchCommand || [],
                running: running
            })
        }
        fallbackItems = results
    }

    function activateFallback(entry) {
        if (root.focusFallbackWindow(entry)) {
            return
        }

        const command = entry.launchCommand || []
        if (command.length === 0) {
            return
        }

        launchProcess.command = command
        launchProcess.running = true
    }

    function focusFallbackWindow(entry) {
        const windowClass = entry.windowClass || ""
        if (windowClass.length === 0) {
            return false
        }

        Hyprland.refreshToplevels()

        const targetClass = windowClass.toLowerCase()
        const toplevels = Hyprland.toplevels.values
        for (let i = 0; i < toplevels.length; i++) {
            const toplevel = toplevels[i]
            const ipcObject = toplevel.lastIpcObject || {}
            const className = (ipcObject.class || "").toLowerCase()
            if (className === targetClass) {
                Hyprland.dispatch("focuswindow class:" + windowClass)
                return true
            }
        }

        return false
    }
}
