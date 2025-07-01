import Quickshell
import QtQuick
import "Workspace"
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
                color: "#E6C871"

                topRightRadius: 12  
                bottomRightRadius: 12
            }

            OsIcon {
                anchors {
                    top: parent.top
                    topMargin: 14
                    horizontalCenter: parent.horizontalCenter
                }
            }

            Workspace {
                anchors {
                    top: parent.top
                    topMargin: 50 
                    horizontalCenter: parent.horizontalCenter
                }                
            }

            ClockWidget {
                anchors {
                    bottom: parent.bottom
                    horizontalCenter: parent.horizontalCenter
                    bottomMargin: 14 
                }
            }
        }
    }

}

