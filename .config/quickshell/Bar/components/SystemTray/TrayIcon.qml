// Individual tray icon component
// Renders icon from SystemTray service (D-Bus StatusNotifierItem)
// Icons are desaturated and tinted with theme color to match bar style
// Left-click activates, right-click secondary activates, hover shows name
// Fallback chain: tray icon -> DesktopEntries lookup -> Material icon

import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "root:/Theme"

Rectangle {
    id: root

    width: 20
    height: 20
    color: "transparent"

    // Strip query parameters from icon path (e.g., "steam_tray_mono?path=/home/..." -> "steam_tray_mono")
    property string cleanIcon: {
        const raw = modelData ? modelData.icon || "" : ""
        const qIdx = raw.indexOf("?")
        return qIdx > 0 ? raw.substring(0, qIdx) : raw
    }

    // Try to resolve icon via DesktopEntries, stripping known suffixes
    function lookupIcon(appId) {
        if (!appId || appId.length === 0) return ""
        const entry = DesktopEntries.heuristicLookup(appId)
        if (entry?.icon) {
            const path = Quickshell.iconPath(entry.icon)
            if (path && path !== "image://icon/") return path
        }
        // Strip known suffixes (e.g., "spotify-linux-32" -> "spotify")
        const stripped = appId.replace(/-linux(-\d+)?$/, "")
        if (stripped !== appId) {
            const strippedEntry = DesktopEntries.heuristicLookup(stripped)
            if (strippedEntry?.icon) {
                const path = Quickshell.iconPath(strippedEntry.icon)
                if (path && path !== "image://icon/") return path
            }
        }
        return ""
    }

    // Resolve icon via DesktopEntries: try id, cleanIcon, title
    property string resolvedIcon: {
        if (!modelData) return ""
        const fromId = lookupIcon(modelData.id)
        if (fromId.length > 0) return fromId
        const fromIcon = lookupIcon(root.cleanIcon)
        if (fromIcon.length > 0) return fromIcon
        const fromTitle = lookupIcon(modelData.title)
        if (fromTitle.length > 0) return fromTitle
        return ""
    }

    // Whether each icon source loaded successfully
    property bool hasDirectIcon: root.cleanIcon.length > 0 && trayIcon.status === Image.Ready
    property bool hasResolvedIcon: root.resolvedIcon.length > 0 && resolvedImage.status === Image.Ready
    property bool hasImageIcon: root.hasDirectIcon || root.hasResolvedIcon

    // Primary icon: try tray icon directly
    IconImage {
        id: trayIcon
        source: root.cleanIcon
        anchors.fill: parent
        mipmap: true
        visible: false
    }

    // Secondary icon: DesktopEntries resolved fallback
    IconImage {
        id: resolvedImage
        source: root.resolvedIcon
        anchors.fill: parent
        mipmap: true
        visible: false
    }

    // Pick the working icon for the pipeline (null if none loaded)
    property var activeIcon: {
        if (root.hasDirectIcon) return trayIcon
        if (root.hasResolvedIcon) return resolvedImage
        return null
    }

    // Desaturate to grayscale
    Desaturate {
        id: desaturatedIcon
        anchors.fill: parent
        source: root.activeIcon
        desaturation: 1.0
        visible: false
    }

    // Tinted overlay (visible when any icon loaded)
    ColorOverlay {
        id: tintedIcon
        anchors.fill: parent
        source: desaturatedIcon
        color: Theme.secondaryColor
        visible: root.hasImageIcon
    }

    // Material icon fallback (visible when no image icon available)
    Text {
        anchors.centerIn: parent
        text: "apps"
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: Theme.secondaryColor
        visible: !root.hasImageIcon
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: (event) => {
            if (!modelData) return
            if (event.button === Qt.LeftButton) {
                modelData.activate()
            } else if (event.button === Qt.RightButton) {
                modelData.secondaryActivate()
            }
        }

        onEntered: {
            trayPopup.showPopup()
        }

        onExited: {
            hideTimer.start()
        }
    }

    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!trayPopup.containsMouse) {
                trayPopup.hidePopup()
            }
        }
    }

    TrayPopup {
        id: trayPopup
        anchorItem: root
        appName: modelData ? (modelData.title || modelData.id || "") : ""
        isFallback: false

        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }
}
