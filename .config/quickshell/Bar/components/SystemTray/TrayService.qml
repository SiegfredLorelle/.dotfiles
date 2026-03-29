// System Tray singleton service
// Primary: Quickshell.Services.SystemTray (D-Bus StatusNotifierItem)
// Fallback: pgrep-based process watchlist for daemons without tray icons
// Pattern: pragma Singleton + Singleton type

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray

Singleton {
    id: root

    // Tray items from D-Bus (event-driven, no polling)
    readonly property list<var> trayItems: SystemTray.items.values

    // Fallback process watchlist for daemons without tray icons
    readonly property list<var> watchlist: [
        { name: "dockerd",      displayName: "Docker",     icon: "deployed_code" },
        { name: "syncthing",    displayName: "Syncthing",  icon: "sync" },
        { name: "tailscaled",   displayName: "Tailscale",  icon: "lan" },
        { name: "mpd",          displayName: "MPD",        icon: "music_note" },
    ]

    // Fallback results: [{name, displayName, icon, running}]
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
                running: running
            })
        }
        fallbackItems = results
    }
}
