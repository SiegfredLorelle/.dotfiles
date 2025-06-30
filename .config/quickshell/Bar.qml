import Quickshell
import QtQuick

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
                color: "#F5DEB3"

                topRightRadius: 12  
                bottomRightRadius: 12
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

