import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import Qt5Compat.GraphicalEffects
import "root:/Theme"

Rectangle {
    id: workspaceContainerWorks
    width: 36
    height: childrenRect.height + 16  // Auto-height based on content + padding
    radius: width / 2
    color: Theme.primaryLightColor 
    border.color: Theme.primaryLightColor
    border.width: 1

    // All 10 possible workspaces, index represents workspace id, null if unused
    property var allWorkspaces: {
        var workspaces = new Array(10).fill(null);
            for (var workspace of Hyprland.workspaces.values) {
                workspaces[workspace.id - 1] = workspace
            }
        console.log("RAN")
        return workspaces;
    }

    function getAppIcon(name): string {
        // Refresh the top levels to make sure it is updated
        Hyprland.refreshToplevels()
        // TODO: Check if in icons that are manually changed from downloaded icons, material icons or nerd fonts
        
         // IF STEAM_APP_DEFAULT CHECK THE TITLE (GENSHIN IMPACT and HOYOPLAY)

         // DEBUG qml: steam_app_default undefined
         // DEBUG qml: kitty kitty
         // DEBUG qml: steam_app_default undefined
         // DEBUG qml: net.lutris.Lutris net.lutris.Lutris
         
        // Get the icon name base on desktop entries
        const quickshellIconName = DesktopEntries.heuristicLookup(name)?.icon
        console.log(name, quickshellIconName)

        const iconPath = Quickshell.iconPath(quickshellIconName)


        if (iconPath) {
            return iconPath
        }
        // TODO: add fallback for apps that are not saved in deskop entries
        return ""
    }


    Column {
        spacing: 6
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: 8  // Padding from container top
        }

        Repeater {
            model: 10

            Rectangle {
                required property int index
                property var workspace: allWorkspaces[index] ?? null
                property bool isWorkspaceActive: workspace ? workspace.active : false
                property int appCount: workspace ? workspace.toplevels.values.length : 0

                width: appCount > 0 ? 24 : 8
                height: isWorkspaceActive || appCount > 0 ? Math.max(appCount * 24, 16) : 8
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: isWorkspaceActive ? Qt.darker(Theme.primaryColor, 1.1) : Theme.primaryColor

                Behavior on color {
                    ColorAnimation {
                        duration: 60
                    }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressed: {
                        var dispatchCommand = "workspace " + (index + 1).toString()
                        Hyprland.dispatch(dispatchCommand)
                    }
                }

                Column {
                    anchors.centerIn: parent
                    spacing: 4
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        topMargin: 8  // Padding from container top
                    }

                    Repeater {
                        model: workspace ? workspace.toplevels.values : []

                        Item {
                            required property var modelData
                            width: 16
                            height: 16

                            // Rounded mask
                            Rectangle {
                                id: maskRect
                                anchors.fill: parent
                                radius: width / 2
                                visible: false
                            }

                            IconImage {
                                id: appIcon
                                anchors.fill: parent
                                source: getAppIcon(modelData.lastIpcObject.class)
                                mipmap: true
                                visible: false
                            }

                            Desaturate {
                                id: desaturateEffect
                                anchors.fill: parent
                                source: appIcon
                                desaturation: 1.0
                                visible: false // Make invisible to use in the next effect
                            }

                            ColorOverlay {
                                id: colorOverlay
                                anchors.fill: desaturateEffect
                                source: desaturateEffect
                                color: Theme.primaryColorOpaqued // Your semi-transparent color
                                visible: false // Make invisible to apply mask
                            }

                            OpacityMask {
                                anchors.fill: parent
                                source: colorOverlay
                                maskSource: maskRect
                            }
                        }
                    }
                }

            }
        }
    }
}
