// Individual fallback process icon
// Shows configured Material icon for daemons without tray icons
// Slightly dimmed to distinguish from real tray items
// Hover shows name via TrayPopup

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
        hoverEnabled: true

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
        appName: modelData ? modelData.displayName || "" : ""
        isFallback: true

        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }
}
