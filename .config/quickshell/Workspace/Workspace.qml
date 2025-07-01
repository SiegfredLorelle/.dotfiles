import Quickshell
import Quickshell.Hyprland
import QtQuick

Rectangle {
    id: workspaceContainer
    
    width: 36 
    height: childrenRect.height + 16  // Auto-height based on content + padding
    radius: 24 
    color: "#edd89b"
    border.color: "#edd89b"
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
                    return "#E6C871"
                }


                Text {
                    anchors.centerIn: parent
                    text: workspace.id == "10" ? "0" : workspace.id
                    font.family: "JetBrainsMono Nerd Font"
                    font.pointSize: isActive ? 11 : 8
                    color: {
                        return "#236376"
                    }
                    font.bold: parent.isActive
                }

            }
        }
    }
}
