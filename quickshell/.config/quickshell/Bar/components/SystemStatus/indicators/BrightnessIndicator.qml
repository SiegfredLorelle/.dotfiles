import QtQuick
import "root:/Theme"
import "../data"

Rectangle {
    id: root
    width: 20
    height: 20
    color: "transparent"
    visible: BrightnessService.available
    
    function getIcon() {
        if (BrightnessService.brightness >= 70) return "brightness_high"
        if (BrightnessService.brightness >= 30) return "brightness_medium"
        return "brightness_low"
    }
    
    Text {
        anchors.centerIn: parent
        text: getIcon()
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: Theme.secondaryColor
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onWheel: (wheel) => {
            const delta = wheel.angleDelta.y > 0 ? 5 : -5
            BrightnessService.setBrightness(BrightnessService.brightness + delta)
        }
        onEntered: brightnessPopup.showPopup()
        onExited: hideTimer.start()
    }
    
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: if (!brightnessPopup.containsMouse) brightnessPopup.hidePopup()
    }
    
    BrightnessPopup {
        id: brightnessPopup
        anchorItem: root
        onContainsMouseChanged: {
            if (containsMouse) hideTimer.stop()
            else hideTimer.start()
        }
    }
}
