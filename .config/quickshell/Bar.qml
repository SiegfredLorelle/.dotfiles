import Quickshell

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            property var modelData
            screen: modelData

            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: 20

            ClockWidget {
                anchors.centerIn: parent
            }
        }
    }

}

