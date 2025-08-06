import Quickshell
import Quickshell.Hyprland
import QtQuick
import "root:/Theme"

Rectangle {
    id: activeWindowContainer
    width: 50
    height: windowText.contentWidth + 36
    color: Theme.primaryColor

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onPressed: Hyprland.activeToplevel?.workspace.activate()
    }


    Text {
        id: windowText
        anchors.centerIn: parent
        rotation: 90
        width: parent.width
        horizontalAlignment: Text.AlignHCenter

        property int maxChars: 32
        text: {
            var fullText = Hyprland.activeToplevel?.title ?? "Desktop";
            if (fullText.length > maxChars) {
                return fullText.substring(0, maxChars) + "...";
            }
            else {
                return fullText;
            }
        }
        font.family: Theme.primaryFont
        font.pointSize: Theme.normalFontSize
        color: Theme.secondaryColor
    }
}
