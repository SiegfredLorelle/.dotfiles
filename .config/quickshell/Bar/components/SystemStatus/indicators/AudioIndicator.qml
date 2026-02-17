// Audio indicator widget
// Shows volume icon that changes based on mute state
// Click to toggle mute, scroll to adjust volume
// Hover for popup with volume slider

import QtQuick
import "root:/Theme"
import "../data"

Rectangle {
    id: root
    width: 20
    height: 20
    color: "transparent"
    visible: AudioService.available
    
    // Icon property
    property string icon: getIcon()
    property color iconColor: AudioService.isMuted ? Theme.opaqueSecondaryColor : Theme.secondaryColor
    
    function getIcon() {
        if (AudioService.isMuted) return "volume_off"
        if (AudioService.volume === 0) return "volume_mute"
        if (AudioService.volume < 50) return "volume_down"
        return "volume_up"
    }
    
    // Icon display
    Text {
        anchors.centerIn: parent
        text: root.icon
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: root.iconColor
    }
    
    // Mouse area for interactions
    MouseArea {
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
        
        onEntered: {
            audioPopup.showPopup()
        }
        
        onExited: {
            hideTimer.start()
        }
    }
    
    // Timer to delay hiding the popup
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!audioPopup.containsMouse) {
                audioPopup.hidePopup()
            }
        }
    }
    
    // Audio popup
    AudioPopup {
        id: audioPopup
        anchorItem: root
        
        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }
    
    // Update icon when volume changes
    Connections {
        target: AudioService
        function onVolumeChanged() { root.icon = getIcon() }
        function onIsMutedChanged() { root.icon = getIcon() }
    }
}
