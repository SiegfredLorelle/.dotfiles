// System Tray bar widget
// Displays tray icons (from D-Bus) and fallback process icons (from pgrep)
// Positioned between ActiveWindow and SystemStatus in the vertical bar

import QtQuick
import Quickshell
import "root:/Theme"

Column {
    id: root

    spacing: Theme.smallSpacing
    width: 20

    // Tray items from D-Bus StatusNotifierItem
    Repeater {
        model: ScriptModel {
            values: TrayService.trayItems
        }
        TrayIcon {}
    }

    // Fallback process items (daemons without tray icons)
    Repeater {
        model: ScriptModel {
            values: TrayService.runningFallbackItems
        }
        FallbackIcon {}
    }
}
