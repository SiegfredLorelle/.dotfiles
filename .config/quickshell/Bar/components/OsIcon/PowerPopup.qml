import QtQuick
import Quickshell
import Quickshell.Io
import "root:/Theme"

AnimatedPopup {
    id: root

    implicitWidth: 250 + 8 * 2
    implicitHeight: archNewsSection.newsExpanded ? 300 : 90
    leftMargin: 34.3

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

    onVisibleChanged: {
        if (!visible) {
            archNewsSection.newsExpanded = false
        }
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

            PowerActionButton {
                id: lockButton
                iconName: "lock"
                tooltipText: "Lock Screen"
                onClicked: {
                    lockProcess.running = true
                    root.hidePopup()
                }
            }

            PowerActionButton {
                id: logoutButton
                iconName: "logout"
                tooltipText: "Logout"
                onClicked: {
                    logoutProcess.running = true
                    root.hidePopup()
                }
            }

            PowerActionButton {
                id: shutdownButton
                iconName: "power_settings_new"
                tooltipText: "Shutdown"
                onClicked: {
                    shutdownProcess.running = true
                    root.hidePopup()
                }
            }

            PowerActionButton {
                id: rebootButton
                iconName: "restart_alt"
                tooltipText: "Reboot"
                onClicked: {
                    rebootProcess.running = true
                    root.hidePopup()
                }
            }
        }

        ArchNewsSection {
            id: archNewsSection
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }
}
