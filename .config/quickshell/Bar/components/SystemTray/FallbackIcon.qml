// Individual fallback process icon
// Shows a custom icon file (from AppIconCache) for daemons without tray icons,
// styled to match TrayIcon and Workspace (desaturate -> gold tint -> circular mask).
// No glyph fallback: a daemon with no matching file renders a blank chip.
// Left-click focuses or opens configured target

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
    color: Theme.primaryColor  // gold chip, matching TrayIcon and Workspace

    // Resolve the configured base filename to a custom icon file url.
    // Gated on AppIconCache.ready so the binding re-evaluates after the scan.
    property string resolvedIcon: {
        if (!AppIconCache.ready || !modelData) return ""
        return AppIconCache.lookup(modelData.icon || "")
    }
    property bool hasImageIcon: root.resolvedIcon.length > 0 && fallbackImage.status === Image.Ready

    // Icon area, inset from the chip edges for padding (mirrors TrayIcon)
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

        IconImage {
            id: fallbackImage
            source: root.resolvedIcon
            anchors.fill: parent
            mipmap: true
            visible: false
        }

        // Desaturate to grayscale (matches Workspace/TrayIcon app-icon treatment)
        Desaturate {
            id: desaturatedIcon
            anchors.fill: parent
            source: fallbackImage
            desaturation: 1.0
            visible: false
        }

        // Tint with translucent gold (matches Workspace/TrayIcon app-icon overlay)
        ColorOverlay {
            id: tintedIcon
            anchors.fill: parent
            source: desaturatedIcon
            color: Theme.primaryColorOpaqued
            visible: false
        }

        // Faint gold icon clipped to the chip (visible when the icon loaded)
        OpacityMask {
            anchors.fill: parent
            source: tintedIcon
            maskSource: maskRect
            visible: root.hasImageIcon
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            if (modelData) {
                TrayService.activateFallback(modelData)
            }
        }
    }
}
