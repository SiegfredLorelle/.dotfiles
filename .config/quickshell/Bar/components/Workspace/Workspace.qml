import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.Notifications
import Quickshell.Widgets
import QtQuick
import Qt5Compat.GraphicalEffects
import "root:/Services"
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
        return workspaces;
    }

    // Resolve a window to an icon: DesktopEntries first, then a custom icon file
    // from the shared AppIconCache (drop a file in ~/Pictures/assets/icons/apps).
    function getAppIcon(app): string {
        Hyprland.refreshToplevels()

        const appName = app.lastIpcObject.class

        const quickshellIconName = DesktopEntries.heuristicLookup(appName)?.icon
        if (quickshellIconName !== undefined) {
            const iconPath = Quickshell.iconPath(quickshellIconName)
            if (iconPath && iconPath !== "image://icon/") {
                return iconPath
            }
        }

        // Fall back to a custom icon file keyed by the window title.
        // Reading AppIconCache.ready binds re-evaluation to the scan completing.
        if (AppIconCache.ready) {
            return AppIconCache.lookup(app.title || "")
        }
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

                width: appCount > 0 ? 24 : 6
                height: isWorkspaceActive || appCount > 0 ? Math.max(appCount * 24, 14) : 6
                radius: width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                color: isWorkspaceActive ? Qt.darker(Theme.primaryColor, 1.1) : Theme.primaryColor

                Behavior on color {
                    ColorAnimation {
                        duration: 60
                    }
                }

                // Hit area is sized to the full pill width + one inter-dot gap
                // instead of filling the tiny dot (idle dots are only 6px), so the
                // whole workspace band is clickable. The dot's own width/height
                // still drive the visuals; this overflows the parent (no clip).
                MouseArea {
                    id: mouseArea
                    anchors.centerIn: parent
                    width: workspaceContainerWorks.width
                    height: parent.height + 6
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    onPressed: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (index + 1) + " })")
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

                            property string iconSource: getAppIcon(modelData)
                            property bool hasAppIcon: iconSource !== ""

                            // Rounded mask for app icons
                            Rectangle {
                                id: maskRect
                                anchors.fill: parent
                                radius: width / 2
                                visible: false
                            }

                            Item {
                                anchors.fill: parent
                                visible: hasAppIcon

                                IconImage {
                                    id: appIcon
                                    anchors.fill: parent
                                    source: iconSource
                                    mipmap: true
                                    visible: false
                                }

                                Desaturate {
                                    id: desaturateEffect
                                    anchors.fill: parent
                                    source: appIcon
                                    desaturation: 1.0
                                    visible: false
                                }

                                ColorOverlay {
                                    id: colorOverlay
                                    anchors.fill: desaturateEffect
                                    source: desaturateEffect
                                    color: Theme.primaryColorOpaqued
                                    visible: false
                                }

                                OpacityMask {
                                    anchors.fill: parent
                                    source: colorOverlay
                                    maskSource: maskRect
                                }
                            }

                            // Material icon fallback (when no app icon)
                            Rectangle {
                                anchors.fill: parent
                                radius: width / 2
                                color: Theme.primaryColorOpaqued
                                visible: !hasAppIcon

                                Text {
                                    text: "terminal"
                                    font.family: Theme.iconFont
                                    font.variableAxes: Theme.iconFontStyle
                                    font.pixelSize: 14 // Adjust size to fit within 16x16
                                    color: "#857959"
                                    anchors.centerIn: parent
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
