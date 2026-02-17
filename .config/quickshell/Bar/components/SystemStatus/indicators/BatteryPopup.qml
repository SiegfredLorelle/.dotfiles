import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/Theme"
import "../data"

AnimatedPopup {
    id: root
    
    width: 180
    height: 60
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
            font.pointSize: Theme.normalFontSize
            color: Theme.primaryColor
        }
        
        Text {
            text: BatteryService.charging ? "Charging: " + BatteryService.level + "%" : "Battery: " + BatteryService.level + "%"
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
            color: BatteryService.level < 20 ? Theme.primaryColor : Theme.secondaryColor
        }
    }
}
