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
                id: backgroundRect
                anchors.fill: parent
                color: Theme.primaryColor
                opacity: 0.9  // Main transparency
                topRightRadius: Theme.borderRadius
                bottomRightRadius: Theme.borderRadius
            }
            
            // Glassmorphism overlay
            Rectangle {
                anchors.fill: parent
                gradient: Gradient {
                    GradientStop { position: 0.0; color: "#40FFFFFF" }  // White tint at top
                    GradientStop { position: 0.5; color: "#20FFFFFF" }  // Less in middle
                    GradientStop { position: 1.0; color: "#10FFFFFF" }  // Minimal at bottom
                }
                topRightRadius: Theme.borderRadius
                bottomRightRadius: Theme.borderRadius
                opacity: 0.6
            }
            
            // Border for glassmorphism effect
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border.color: "#60FFFFFF"  // Semi-transparent white border
                border.width: 1
                topRightRadius: Theme.borderRadius
                bottomRightRadius: Theme.borderRadius
            }
            
             // Subtle inner shadow effect
            Rectangle {
                anchors {
                    fill: parent
                    margins: 1
                }
                color: "transparent"
                border.color: "#20000000"  // Very subtle dark inner border
                border.width: 1
                topRightRadius: Theme.borderRadius - 1
                bottomRightRadius: Theme.borderRadius - 1
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
