import Quickshell
import QtQuick
import "components/Workspace"
import "components/ClockWidget"
import "components/OsIcon"
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
            
            GlassEffects {
                anchors.fill: parent
                rightRadius: true  // Only right side has radius
                baseColor: Theme.primaryColor
                borderRadius: Theme.borderRadius
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

//             ActiveWindow {
//                 anchors {
//                     verticalCenter: parent.verticalCenter 
//                 }
//             }
//
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
