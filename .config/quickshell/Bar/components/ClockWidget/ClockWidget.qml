import QtQuick
import "root:/Theme"

Column {
    id: root
    spacing: 4
    
    // Main date/time display with mouse area
    MouseArea {
        width: dateTimeColumn.width
        height: dateTimeColumn.height
        hoverEnabled: true
        
        Column {
            id: dateTimeColumn
            anchors.horizontalCenter: parent.horizontalCenter
            
            Column {
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    id: day 
                    text: Time.format("ddd")
                    font.family: Theme.primaryFont
                    color: Theme.secondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: Theme.normalFontSize 
                }
                Text {
                    id: date 
                    text: Time.format("dd\nMM")
                    font.family: Theme.primaryFont
                    font.pointSize: Theme.normalFontSize 
                    color: Theme.secondaryColor
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Text {
                id: timeIcon
                text: "―"
                font.family: Theme.primaryFont 
                font.pointSize: Theme.largeFontSize
                color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }

            Text {
                id: time 
                text: Time.format("hh\nmm\nss")
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize 
                color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
        
        // Show calendar on hover
        onEntered: {
            clockPopup.visible = true
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
            if (!clockPopup.containsMouse) {
                clockPopup.visible = false
            }
        }
    }
    
    // Calendar popup - now just a simple instantiation
    ClockPopup {
        id: clockPopup
        anchorItem: root
        visible: false
        
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
