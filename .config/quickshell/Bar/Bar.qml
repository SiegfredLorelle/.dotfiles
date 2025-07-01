import Quickshell
import QtQuick
import "components/Workspace"
import "components/ClockWidget"
import "components"
import "root:/Theme"

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData
            color: "transparent"

            anchors {
                top: true
                bottom: true
                left: true
            }
            implicitWidth: 50 

            Rectangle {
                anchors.fill: parent
                color: Theme.primaryColor

                topRightRadius: Theme.borderRadius 
                bottomRightRadius: Theme.borderRadius 
            }

            OsIcon {
                anchors {
                    top: parent.top
                    topMargin: Theme.barGap 
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Workspace {
                anchors {
                    top: parent.top
                    topMargin: Theme.barGap + 40 
                    horizontalCenter: parent.horizontalCenter
                }                
            }

            ClockWidget {
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: Theme.barGap 
                }
            }
        }
    }

}

