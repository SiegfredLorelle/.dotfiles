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

                width: isActive ? 28 : 20 
                height: isActive ? 28 : 20
                radius: width / 2 
                anchors.horizontalCenter: parent.horizontalCenter
                color: {
                    return Theme.primaryColor
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
