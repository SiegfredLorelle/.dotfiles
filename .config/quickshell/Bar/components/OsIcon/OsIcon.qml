import QtQuick
import "root:/Theme"

Item {
    id: root
    width: osIcon.width
    height: osIcon.height
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        
        Text {
            id: osIcon
            text: "󰣇"
            font.family: Theme.normalFontSize 
            font.pointSize: Theme.iconSize 
            color: Theme.secondaryColor
            anchors.centerIn: parent
        }
        
        onEntered: {
            powerPopup.showPopup()
        }
        
        onExited: {
            // Add small delay to prevent flickering
            hideTimer.start()
        }
    }
    
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!powerPopup.containsMouse) {
                powerPopup.hidePopup()
            }
        }
    }
    
    PowerPopup {
        id: powerPopup
        anchorItem: root
        
        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }
}
