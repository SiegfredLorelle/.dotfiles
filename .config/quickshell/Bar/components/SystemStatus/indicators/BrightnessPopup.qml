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
            text: "Brightness"
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
            color: Theme.primaryColor
        }
        
        Text {
            text: BrightnessService.brightness + "%"
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
            color: Theme.secondaryColor
        }
    }
}
