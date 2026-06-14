import Quickshell
import QtQuick
import "components/Workspace"
import "components/ClockWidget"
import "components/OsIcon"
import "components/ActiveWindow"
import "components/Performance"
import "components/SystemStatus"
import "components/SystemTray"
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
            implicitWidth: Theme.barWindowWidth
            exclusiveZone: Theme.barExclusiveZone
            
            Rectangle {
                id: mainBar
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                }
                width: Theme.barWidth
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
            RoundCorner {
                anchors {
                    top: cornerRectangle.top
                    left: cornerRectangle.left
                }
                size: Theme.barCornerSize
                color: Theme.primaryColor
                corner: RoundCorner.CornerEnum.TopLeft
            }
            
            RoundCorner {
                anchors {
                    bottom: cornerRectangle.bottom
                    left: cornerRectangle.left
                }
                size: Theme.barCornerSize
                color: Theme.primaryColor
                corner: RoundCorner.CornerEnum.BottomLeft
            }
            
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

            // SystemTray - between ActiveWindow and SystemStatus
            SystemTray {
                id: systemTrayComponent
                anchors {
                    bottom: systemStatusComponent.top
                    bottomMargin: Theme.barGap
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            // SystemStatus - between SystemTray and PerformanceMonitor
            SystemStatus {
                id: systemStatusComponent
                anchors {
                    bottom: performanceMonitorComponent.top
                    bottomMargin: Theme.barGap
                    horizontalCenter: mainBar.horizontalCenter
                }
            }

            // Performance Monitor - between SystemStatus and ClockWidget
            PerformanceMonitor {
                id: performanceMonitorComponent
                anchors {
                    bottom: clockWidgetComponent.top
                    bottomMargin: Theme.barGap
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
