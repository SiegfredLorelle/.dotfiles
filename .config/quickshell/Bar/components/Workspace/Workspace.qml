import Quickshell
import Quickshell.Hyprland
import QtQuick
import "root:/Theme"

Rectangle {
    id: workspaceContainer
    
    width: 36 
    height: childrenRect.height + 16  // Auto-height based on content + padding
    radius: width / 2 
    color: Theme.primaryLightColor 
    border.color: Theme.primaryLightColor
    border.width: 1

    Column {
        spacing: 4 
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 8  // Padding from container top
        }
        Repeater {
            model: Hyprland.workspaces

            Rectangle {
                property var workspace: modelData
                property bool isActive: workspace.id === Hyprland.focusedWorkspace?.id
                property bool hasWindows: workspace.windows.length > 0
                property bool isPressed: mouseArea.pressed

                width: isActive ? 28 : 20 
                height: isActive ? 28 : 20
                radius: width / 2 
                anchors.horizontalCenter: parent.horizontalCenter
                color: {
                    if (isPressed) {
                        return Qt.darker(Theme.primaryColor, 1.1)
                    }
                    return Theme.primaryColor
                }
                scale: isPressed ? 0.9 : 1.0
                Behavior on scale {
                    NumberAnimation {
                        duration: 100
                        easing.type: Easing.OutQuad
                    }
                }

                Behavior on color {
                    ColorAnimation {
                        duration: 100
                    }
                }
                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor 
                    onPressed: {
                        workspace.activate()
                    }
                }
                Text {
                    anchors.centerIn: parent
                    text: workspace.id == "10" ? "0" : workspace.id
                    font.family: Theme.primaryFont 
                    font.pointSize: isActive ? Theme.mediumFontSize : Theme.normalFontSize
                    color: {
                        return Theme.secondaryColor 
                    }
                    font.bold: parent.isActive
                }

            }
        }
    }
}
