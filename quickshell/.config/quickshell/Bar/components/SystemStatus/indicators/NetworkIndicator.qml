import QtQuick
import "root:/Theme"
import "../data"

Rectangle {
    id: root
    width: 20
    height: 20
    color: "transparent"
    visible: NetworkService.available
    
    Text {
        anchors.centerIn: parent
        text: NetworkService.connected ? "wifi" : "wifi_off"
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: NetworkService.connected ? Theme.secondaryColor : Theme.opaqueSecondaryColor
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: NetworkService.toggleWifi()
        onEntered: networkPopup.showPopup()
        onExited: hideTimer.start()
    }
    
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: if (!networkPopup.containsMouse) networkPopup.hidePopup()
    }
    
    NetworkPopup {
        id: networkPopup
        anchorItem: root
        onContainsMouseChanged: {
            if (containsMouse) hideTimer.stop()
            else hideTimer.start()
        }
    }
}
