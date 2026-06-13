// Individual fallback process icon: a custom icon file (from AppIconCache) for
// daemons without tray icons, styled like TrayIcon (desaturate -> gold tint -> mask).
// Left-click focuses the window or runs the configured launch command.

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
    color: Theme.primaryColor  // gold chip

    // Resolve the configured base filename to a custom icon file url.
    // Gated on AppIconCache.ready so the binding re-evaluates after the scan.
    property string resolvedIcon: {
        if (!AppIconCache.ready || !modelData) return ""
        return AppIconCache.lookup(modelData.icon || "")
    }
    property bool hasImageIcon: root.resolvedIcon.length > 0 && fallbackImage.status === Image.Ready

    // Icon area, inset from the chip edges for padding
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

        // Recolor to match the theme: desaturate to gray, then tint gold
        Desaturate {
            id: desaturatedIcon
            anchors.fill: parent
            source: fallbackImage
            desaturation: 1.0
            visible: false
        }

        ColorOverlay {
            id: tintedIcon
            anchors.fill: parent
            source: desaturatedIcon
            color: Theme.primaryColorOpaqued
            visible: false
        }

        // Final icon, clipped to the chip
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
