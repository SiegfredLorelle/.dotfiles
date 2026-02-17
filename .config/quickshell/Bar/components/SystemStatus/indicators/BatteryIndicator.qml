import QtQuick
import "root:/Theme"
import "../data"

Rectangle {
    id: root
    width: 20
    height: 20
    color: "transparent"
    visible: BatteryService.available
    
    function getIcon() {
        if (BatteryService.level >= 80) return "battery_full"
        if (BatteryService.level >= 60) return "battery_60"
        if (BatteryService.level >= 40) return "battery_40"
        if (BatteryService.level >= 20) return "battery_20"
        return "battery_alert"
    }
    
    Text {
        anchors.centerIn: parent
        text: getIcon()
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: BatteryService.charging ? Theme.primaryColor : Theme.secondaryColor
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onEntered: batteryPopup.showPopup()
        onExited: hideTimer.start()
    }
    
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: if (!batteryPopup.containsMouse) batteryPopup.hidePopup()
    }
    
    BatteryPopup {
        id: batteryPopup
        anchorItem: root
        onContainsMouseChanged: {
            if (containsMouse) hideTimer.stop()
            else hideTimer.start()
        }
    }
}
