import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "root:/Theme"

AnimatedPopup {
    id: root

    width: 250 + 8 * 2
    height: newsExpanded ? 300 : 90
    leftMargin: 34.3

    property bool newsExpanded: false
    property var newsItems: []

    Process {
        id: logoutProcess
        command: ["sh", "-c", "hyprctl dispatch exit"]
        running: false
        onExited: {
            running = false
            console.log("Logout command executed")
        }
    }

    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
        running: false
        onExited: {
            running = false
            console.log("Shutdown command executed")
        }
    }

    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
        running: false
        onExited: {
            running = false
            console.log("Reboot command executed")
        }
    }

    Process {
        id: lockProcess
        command: ["sh", "-c", "hyprlock"]
        running: false
        onExited: {
            running = false
            console.log("Lock command executed")
        }
    }

    function fetchArchNews() {
        newsItems = [
            { title: "Arch Linux Update 2024.12.01", date: "2024-12-01", summary: "Latest kernel updates..." },
            { title: "Security Advisory: OpenSSL Update", date: "2024-11-28", summary: "Important security fixes..." },
            { title: "KDE Plasma 6.2 Available", date: "2024-11-25", summary: "New features in KDE..." }
        ]
    }

    onVisibleChanged: {
        if (visible) fetchArchNews()
        else newsExpanded = false
    }

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Button {
                id: lockButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "lock"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    lockProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Lock Screen"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: logoutButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "logout"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    logoutProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Logout"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: shutdownButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "power_settings_new"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    shutdownProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Shutdown"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: rebootButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "restart_alt"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    rebootProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Reboot"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }
        }

        Button {
            id: newsToggleButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: 215
            height: 30
            background: Rectangle {
                color: parent.hovered ? Theme.primaryLightColor : "transparent"
                radius: 6
                opacity: parent.hovered ? 0.8 : 1.0
            }
            contentItem: Row {
                anchors.centerIn: parent
                spacing: 4
                Text {
                    text: "rss_feed"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.mediumFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "Arch News"
                    font.family: Theme.textFont
                    font.pointSize: Theme.normalFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: newsExpanded ? "unfold_less" : "unfold_more"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.mediumFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            onClicked: newsExpanded = !newsExpanded
            ToolTip.text: newsExpanded ? "Hide Arch News" : "Show Arch News"
            ToolTip.visible: hovered
            ToolTip.delay: 0
        }

        ScrollView {
            id: newsScrollView
            width: parent.width
            height: newsExpanded ? 200 : 0
            anchors.horizontalCenter: parent.horizontalCenter
            visible: newsExpanded

            Behavior on height {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            Column {
                width: newsScrollView.width
                spacing: 4

                Repeater {
                    model: newsItems
                    delegate: Rectangle {
                        width: parent.width
                        height: newsItemColumn.height + 8
                        color: newsItemMouseArea.containsMouse ? Theme.primaryLightColor : "transparent"
                        radius: 4

                        MouseArea {
                            id: newsItemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: console.log("News item clicked:", modelData.title)
                        }

                        Column {
                            id: newsItemColumn
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 4
                            spacing: 2

                            Text {
                                text: modelData.title
                                font.family: Theme.textFont
                                font.pointSize: Theme.normalFontSize * 0.7
                                font.weight: Font.Medium
                                color: Theme.secondaryColor
                                width: parent.width
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                text: modelData.date
                                font.family: Theme.textFont
                                font.pointSize: Theme.normalFontSize * 0.6
                                color: Theme.secondaryColor
                                opacity: 0.7
                            }

                            Text {
                                text: modelData.summary
                                font.family: Theme.textFont
                                font.pointSize: Theme.normalFontSize * 0.6
                                color: Theme.secondaryColor
                                opacity: 0.8
                                width: parent.width
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                }
            }
        }
    }
}
