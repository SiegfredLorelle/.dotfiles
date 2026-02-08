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

    // Cache for icon paths to avoid repeated searches
    property var iconCache: ({})
    // Add this property to track if icons are cached
    property bool iconsCached: false

    // Pre-cache icons on component completion
    Component.onCompleted: {
        preCacheIcons()
    }

    function preCacheIcons() {
        const appIconDir = Quickshell.env("HOME") + "/Pictures/assets/icons/apps"

        Qt.createQmlObject(`
            import Qt.labs.folderlistmodel 2.15
            FolderListModel {
                folder: "file://${appIconDir}"
                nameFilters: ["*.png", "*.svg", "*.ico"]
                showDirs: false

                onCountChanged: {
                    // Cache all available icons
                    for (let i = 0; i < count; i++) {
                        const fileName = get(i, "fileName")
                        const baseName = fileName.replace(/\\.(png|svg|ico)$/i, "")
                        const fullPath = "file://${appIconDir}/" + fileName

                        // Create cache entries for potential matches
                        iconCache[baseName] = fullPath
                        iconCache[baseName.toLowerCase()] = fullPath
                        iconCache[baseName.replace(/-/g, " ")] = fullPath
                    }

                    iconsCached = true
                    console.log("Icons pre-cached:", Object.keys(iconCache).length)
                    destroy()
                }

                onStatusChanged: {
                    if (status === FolderListModel.Error) {
                        iconsCached = true // Mark as cached even on error to avoid hanging
                        destroy()
                    }
                }
            }`, workspaceContainerWorks)
    }

    // Modified getAppIcon function
    function getAppIcon(app): string {
        Hyprland.refreshToplevels()

        const appName = app.lastIpcObject.class
        const appTitle = app.title.toLowerCase().replace(/ /g, "-")

        // Try desktop entries first
        const quickshellIconName = DesktopEntries.heuristicLookup(appName)?.icon
        if (quickshellIconName !== undefined) {
            const iconPath = Quickshell.iconPath(quickshellIconName)
            if (iconPath && iconPath !== "image://icon/") {
                console.log("Desktop entry icon found:", appName, iconPath)
                return iconPath
            }
        }

        // Check pre-cached icons
        if (iconsCached && appTitle !== "") {
            console.log("Searching cached icons for:", appTitle)

            // Try exact match first
            if (iconCache[appTitle]) {
                console.log("Exact match found:", iconCache[appTitle])
                return iconCache[appTitle]
            }

            // Try partial matches
            for (const cachedName in iconCache) {
                if (cachedName.includes(appTitle) || appTitle.includes(cachedName)) {
                    console.log("Partial match found:", cachedName, "->", iconCache[cachedName])
                    return iconCache[cachedName]
                }
            }

            console.log("No cached icon found for:", appTitle)
        }
        return "" // No app icon found
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

                            property string iconSource: getAppIcon(modelData)
                            property bool hasAppIcon: iconSource !== ""

                            // Rounded mask for app icons
                            Rectangle {
                                id: maskRect
                                anchors.fill: parent
                                radius: width / 2
                                visible: false
                            }

                            // App icon display (when available)
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
                                    color: "#857959" // Or whatever color you prefer
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
