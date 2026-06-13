// System Tray bar widget
// Displays tray icons (from D-Bus) and fallback process icons (from pgrep)
// Positioned between ActiveWindow and SystemStatus in the vertical bar

import QtQuick
import Quickshell
import "root:/Theme"

Rectangle {
    id: root

    // Grouped pill behind the tray icons, mirroring the opened-apps (Workspace) pill:
    // an opaque light-gold surface that lifts the teal icons off the gold bar with clean
    // dark-on-light contrast, matching the Workspace container 1:1.
    width: 36  // matches the Workspace pill width so the two pills align on the bar
    height: trayColumn.implicitHeight + Theme.largeSpacing * 2
    radius: width / 2
    color: Theme.primaryLightColor

    // Hide the pill when there are no items so an empty chip never shows
    visible: TrayService.trayItems.length + TrayService.runningFallbackItems.length > 0

    Column {
        id: trayColumn
        anchors.centerIn: parent
        spacing: Theme.smallSpacing

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
}
