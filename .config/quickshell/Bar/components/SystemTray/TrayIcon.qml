// Individual tray icon component
// Renders icon from SystemTray service (D-Bus StatusNotifierItem)
// Each icon sits on a gold chip with a desaturated, translucent-gold icon on top,
// mirroring the Workspace (opened-apps) recipe so the tray matches that palette
// Left-click activates, right-click secondary activates
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
    radius: width / 2
    color: Theme.primaryColor  // gold chip behind the icon (matches Workspace sub-pills)

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
        if (entry && entry.icon) {
            const path = Quickshell.iconPath(entry.icon)
            if (path && path !== "image://icon/") return path
        }
        // Strip known suffixes (e.g., "spotify-linux-32" -> "spotify")
        const stripped = appId.replace(/-linux(-\d+)?$/, "")
        if (stripped !== appId) {
            const strippedEntry = DesktopEntries.heuristicLookup(stripped)
            if (strippedEntry && strippedEntry.icon) {
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

    // Pick the working icon for the pipeline (null if none loaded)
    property var activeIcon: {
        if (root.hasDirectIcon) return trayIcon
        if (root.hasResolvedIcon) return resolvedImage
        return null
    }

    // Icon area, inset from the chip edges for padding (mirrors Workspace app icons)
    Item {
        id: iconArea
        anchors.fill: parent
        anchors.margins: 3

        // Rounded mask so the icon is clipped to the chip shape
        Rectangle {
            id: maskRect
            anchors.fill: parent
            radius: width / 2
            visible: false
        }

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

        // Desaturate to grayscale
        Desaturate {
            id: desaturatedIcon
            anchors.fill: parent
            source: root.activeIcon
            desaturation: 1.0
            visible: false
        }

        // Tint with translucent gold (matches Workspace app-icon overlay)
        ColorOverlay {
            id: tintedIcon
            anchors.fill: parent
            source: desaturatedIcon
            color: Theme.primaryColorOpaqued
            visible: false
        }

        // Faint gold icon clipped to the chip (visible when any icon loaded)
        OpacityMask {
            anchors.fill: parent
            source: tintedIcon
            maskSource: maskRect
            visible: root.hasImageIcon
        }
    }

    // Material icon fallback (visible when no image icon available)
    Text {
        anchors.centerIn: parent
        text: "apps"
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: Theme.primaryColorOpaqued
        visible: !root.hasImageIcon
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor

        onClicked: (event) => {
            if (!modelData) return
            if (event.button === Qt.LeftButton) {
                modelData.activate()
            } else if (event.button === Qt.RightButton) {
                modelData.secondaryActivate()
            }
        }
    }
}
