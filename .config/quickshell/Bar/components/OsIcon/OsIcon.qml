import QtQuick
import "root:/Theme"

Item {
    id: root
    width: osIcon.width
    height: osIcon.height
    
    // Mouse area for hover detection
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
        
        // Show power popup on hover
        onEntered: {
            powerPopup.showPopup()
        }
        
        onExited: {
            // Add small delay to prevent flickering
            hideTimer.start()
        }
    }
    
    // Timer to delay hiding the popup
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!powerPopup.containsMouse) {
                powerPopup.hidePopup()
            }
        }
    }
    
    // Power popup
    PowerPopup {
        id: powerPopup
        anchorItem: root
        
        // Handle mouse events for hover management
        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }
}
