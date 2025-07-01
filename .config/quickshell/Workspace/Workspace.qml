import Quickshell
import Quickshell.Hyprland
import QtQuick

Column {
    spacing: 4 

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            property var workspace: modelData
            property bool isActive: workspace.id === Hyprland.focusedWorkspace?.id
            property bool hasWindows: workspace.windows.length > 0

            width: isActive ? 30 : 20 
            height: isActive ? 30 : 20
            radius: width / 2 
            anchors.horizontalCenter: parent.horizontalCenter
            color: {
                if (isActive) return "#236376"
                else if (hasWindows) return "#4A9DB8"
                else return "transparent"
            }
            
            border.color: hasWindows ? "#236376" : "#80236376"
            border.width: hasWindows ? 0 : 1

            Text {
                anchors.centerIn: parent
                text: workspace.id == "10" ? "0" : workspace.id
                font.family: "JetBrainsMono Nerd Font"
                font.pointSize: 8
                color: {
                    if (parent.isActive) return "#E6C871"
                    else if (parent.hasWindows) return "#E6C871"
                    else return "#236376"
                }
                font.bold: parent.isActive
            }

        }
    }
}
