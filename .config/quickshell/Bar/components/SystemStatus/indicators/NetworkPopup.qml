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
        glassOpacity: 0.95
        showBorder: true
        borderColor: Theme.lighterPrimaryColor
        borderWidth: 1
        cornerRadius: Theme.borderRadius
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
