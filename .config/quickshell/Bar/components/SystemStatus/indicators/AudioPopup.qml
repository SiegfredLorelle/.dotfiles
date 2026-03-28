// Audio popup showing volume slider and controls
// Extends AnimatedPopup for consistent behavior

import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/Theme"
import "../data"

AnimatedPopup {
    id: root
    
    width: 180
    height: 80
    leftMargin: 35
    
    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    // Interactive area for click and scroll
    MouseArea {
        id: popupMouseArea
        anchors.fill: parent
        hoverEnabled: true

        // Click to toggle mute
        onClicked: {
            AudioService.toggleMute()
        }

        // Scroll to adjust volume
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? 5 : -5
            AudioService.setVolume(AudioService.volume + delta)
        }
    }

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 8
        anchors.topMargin: 0
        spacing: 8
        
        // Header
        Text {
            text: "Audio"
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
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
                font.pointSize: Theme.normalFontSize
                color: Theme.secondaryColor
                anchors.verticalCenter: parent.verticalCenter
            }
            
            Text {
                text: AudioService.isMuted ? "Muted" : AudioService.volume + "%"
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize
                color: Theme.secondaryColor
                anchors.verticalCenter: parent.verticalCenter
            }
        }
        
        // Volume slider (visual only for now)
        Rectangle {
            width: parent.width
            height: 4
            color: Theme.secondaryColorOpaqued
            radius: 2
            
            Rectangle {
                width: parent.width * (AudioService.volume / 100)
                height: parent.height
                color: AudioService.isMuted ? Theme.secondaryColorOpaqued : Theme.secondaryColor
                radius: 2
            }
        }
    }
}
