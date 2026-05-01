// Individual fallback process icon
// Shows configured Material icon for daemons without tray icons
// Slightly dimmed to distinguish from real tray items
// Left-click focuses or opens configured target

import QtQuick
import "root:/Theme"

Rectangle {
    id: root

    width: 20
    height: 20
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: modelData ? modelData.icon || "" : ""
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: Theme.secondaryColor
        opacity: 0.65
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
