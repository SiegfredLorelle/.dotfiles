// Individual tray icon component
// Renders icon from SystemTray service (D-Bus StatusNotifierItem)
// Each icon sits on a gold chip with a desaturated, translucent-gold icon on top,
// mirroring the Workspace (opened-apps) recipe so the tray matches that palette
// Resolution: DesktopEntries lookup (stable) -> SNI tray icon -> Material icon
// Left-click activates, right-click secondary activates

import QtQuick
import Quickshell
import Quickshell.Widgets
import Qt5Compat.GraphicalEffects
import "root:/Services"
import "root:/Theme"

Rectangle {
    id: root

    width: 20
    height: 20
    radius: width / 2
    color: Theme.primaryColor  // gold chip behind the icon (matches Workspace sub-pills)

    // Tray icon URL passed through verbatim. Quickshell encodes some SNI icons
    // with a "?path=" query pointing at the app's icon dir (e.g.
    // "spotify-linux?path=/opt/spotify/...") — IconImage needs it to resolve, so
    // do NOT strip the query.
    property string directIcon: modelData ? modelData.icon || "" : ""

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

    // Resolve icon via DesktopEntries: try id, directIcon, title. If all fail,
    // fall back to a custom icon file (AppIconCache) keyed by id then title, so a
    // dropped file in ~/Pictures/assets/icons/apps can rescue an unresolved app.
    property string resolvedIcon: {
        if (!modelData) return ""
        const fromId = lookupIcon(modelData.id)
        if (fromId.length > 0) return fromId
        const fromIcon = lookupIcon(root.directIcon)
        if (fromIcon.length > 0) return fromIcon
        const fromTitle = lookupIcon(modelData.title)
        if (fromTitle.length > 0) return fromTitle
        if (AppIconCache.ready) {
            const fromCacheId = AppIconCache.lookup(modelData.id || "")
            if (fromCacheId.length > 0) return fromCacheId
            const fromCacheTitle = AppIconCache.lookup(modelData.title || "")
            if (fromCacheTitle.length > 0) return fromCacheTitle
        }
        return ""
    }

    // Whether each icon source loaded successfully
    property bool hasDirectIcon: root.directIcon.length > 0 && trayIcon.status === Image.Ready
    property bool hasResolvedIcon: root.resolvedIcon.length > 0 && resolvedImage.status === Image.Ready
    property bool hasImageIcon: root.hasDirectIcon || root.hasResolvedIcon

    // Pick the working icon for the pipeline (null if none loaded).
    // Prefer the DesktopEntries-resolved icon (stable /usr/share path, same as
    // Workspace) over the SNI-provided icon, which some apps (e.g. Spotify) send
    // intermittently as a blank/failing pixmap.
    property var activeIcon: {
        if (root.hasResolvedIcon) return resolvedImage
        if (root.hasDirectIcon) return trayIcon
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
            source: root.directIcon
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

        // Desaturate to grayscale (matches Workspace app-icon treatment)
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

    // No glyph fallback: an item that resolves via none of DesktopEntries, its
    // SNI icon, or a custom file renders a blank gold chip (glyph-free by design).

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
