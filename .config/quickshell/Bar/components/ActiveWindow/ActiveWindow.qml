import Quickshell
import Quickshell.Hyprland
import QtQuick
import "root:/Theme"

Rectangle {
    id: activeWindowContainer
    width: windowText.implicitWidth
    height: 36
    color: Theme.primaryColor

    // Ensure minimum width for when there's no active window
    property int minimumWidth: 120

    Text {
        id: windowText
        anchors.centerIn: parent
        
        // Get the active window title, fallback to "Desktop" if none
        text: Hyprland.activeToplevel?.title ?? "Desktop"
        
        font.family: Theme.primaryFont
        font.pointSize: Theme.normalFontSize
        color: Theme.secondaryColor
        
        // Elide text if it gets too long
        elide: Text.ElideRight
        maximumLineCount: 1
        
    }
}
