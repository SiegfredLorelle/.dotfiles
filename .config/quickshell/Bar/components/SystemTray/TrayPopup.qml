// System tray tooltip popup
// Shows app name on hover over tray/fallback icons
// Extends AnimatedPopup for consistent behavior

import QtQuick
import Quickshell
import "root:/Theme"

AnimatedPopup {
    id: root

    property string appName: ""
    property bool isFallback: false

    implicitWidth: 160
    implicitHeight: 34
    leftMargin: 35

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Text {
        anchors.centerIn: parent
        text: root.appName
        font.family: Theme.primaryFont
        font.pointSize: Theme.normalFontSize
        color: root.isFallback ? Theme.secondaryLighterColor : Theme.primaryColor
    }
}
