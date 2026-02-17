// Audio popup showing volume slider and controls
// Extends AnimatedPopup for consistent behavior

import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/Theme"
import "../data"

AnimatedPopup {
    id: root
    
    implicitWidth: 180
    implicitHeight: contentColumn.height + 16
    leftMargin: 35
    
    GlassEffects {
        id: glass
        anchors.fill: parent
        glassOpacity: 0.95
        showBorder: true
        borderColor: Theme.lighterPrimaryColor
        borderWidth: 1
        cornerRadius: Theme.borderRadius
    }
    
    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        
        // Header
        Text {
            text: "Audio"
            font.family: Theme.primaryFont
            font.pointSize: Theme.smallFontSize
            color: Theme.primaryColor
        }
        
        // Volume row
        Row {
            spacing: 6
            width: parent.width
            
            Text {
                text: AudioService.isMuted ? "volume_off" : "volume_up"
                font.family: Theme.iconFont
                font.variableAxes: Theme.iconFontStyle
                font.pointSize: Theme.smallFontSize
                color: Theme.secondaryColor
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: AudioService.isMuted ? "Muted" : AudioService.volume + "%"
                font.family: Theme.primaryFont
                font.pointSize: Theme.smallFontSize
                color: Theme.foregroundColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Volume slider (visual only for now)
        Rectangle {
            width: parent.width
            height: 4
            color: Theme.opaqueSecondaryColor
            radius: 2
            
            Rectangle {
                width: parent.width * (AudioService.volume / 100)
                height: parent.height
                color: AudioService.isMuted ? Theme.opaqueSecondaryColor : Theme.secondaryColor
                radius: 2
            }
        }
    }
}
