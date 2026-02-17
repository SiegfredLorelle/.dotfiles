import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/Theme"
import "../data"

AnimatedPopup {
    id: root
    
    implicitWidth: 180
    implicitHeight: 60
    leftMargin: 35
    
    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }
    
    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8
        
        Text {
            text: "Battery"
            font.family: Theme.primaryFont
            font.pointSize: Theme.smallFontSize
            color: Theme.primaryColor
        }
        
        Text {
            text: BatteryService.charging ? "Charging: " + BatteryService.level + "%" : "Battery: " + BatteryService.level + "%"
            font.family: Theme.primaryFont
            font.pointSize: Theme.smallFontSize
            color: BatteryService.level < 20 ? Theme.primaryColor : Theme.foregroundColor
        }
    }
}
