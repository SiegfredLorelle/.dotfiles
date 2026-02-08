import Quickshell
import QtQuick
import "components/Workspace"
import "components/ClockWidget"
import "components/OsIcon"
import "components/ActiveWindow"
import "components/Performance"
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
            implicitWidth: 70 // Accommodates both mainBar and cornerRectangle
            
            Rectangle {
                id: mainBar
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: 50
                color: Theme.primaryColor
            }
            
            Rectangle {
                id: cornerRectangle
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: mainBar.right
                }
            }
            // Top-right rounded corner for cornerRectangle
            RoundCorner {
                anchors {
                    top: cornerRectangle.top
                    left: cornerRectangle.left
                }
                size: 20
                color: Theme.primaryColor
                corner: RoundCorner.CornerEnum.TopLeft
            }
            
            // Bottom-right rounded corner for cornerRectangle
            RoundCorner {
                anchors {
                    bottom: cornerRectangle.bottom
                    left: cornerRectangle.left
                }
                size: 20 
                color: Theme.primaryColor
                corner: RoundCorner.CornerEnum.BottomLeft
            }
            
            // Components inside mainBar
            // Components at the top
            OsIcon {
                anchors {
                    top: mainBar.top
                    topMargin: Theme.barGap
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            Workspace {
                anchors {
                    top: mainBar.top
                    topMargin: Theme.barGap + 40
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            // Components at the center
            ActiveWindow {
                id: activeWindowComponent
                anchors {
                    verticalCenter: mainBar.verticalCenter
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            // Performance Monitor - between ActiveWindow and Clock
            PerformanceMonitor {
                anchors {
                    bottom: clockWidgetComponent.top
                    bottomMargin: Theme.barGap * 2
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            // Components at the bottom
            ClockWidget {
                id: clockWidgetComponent
                anchors {
                    bottom: mainBar.bottom
                    horizontalCenter: mainBar.horizontalCenter
                    bottomMargin: Theme.barGap
                }
            }
        }
    }
}

