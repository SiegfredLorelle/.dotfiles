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
            text: "Network"
            font.family: Theme.primaryFont
            font.pointSize: Theme.smallFontSize
            color: Theme.primaryColor
        }
        
        Text {
            text: NetworkService.connected ? "Connected: " + NetworkService.ssid : "Disconnected"
            font.family: Theme.primaryFont
            font.pointSize: Theme.smallFontSize
            color: Theme.foregroundColor
        }
    }
}
