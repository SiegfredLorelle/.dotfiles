// Performance monitor widget for the bar
// Displays three circular gauges: CPU, Memory, GPU
// Shows hover popup with detailed stats (PerformancePopup.qml)
// Data provided by SystemStats.qml singleton

import QtQuick
import "root:/Theme"

Column {
    id: root
    spacing: Theme.barGap
    width: 24

    // Main container with mouse area
    MouseArea {
        width: parent.width
        height: gaugesColumn.height
        hoverEnabled: true

        Column {
            id: gaugesColumn
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.largeSpacing

            // CPU Gauge
            CircularGauge {
                value: SystemStats.cpuPercent
                icon: "memory"
                color: Theme.secondaryColor
            }

            // Memory Gauge
            CircularGauge {
                value: SystemStats.memoryPercent
                icon: "memory_alt"
                color: Theme.secondaryColor
            }

            // GPU Gauge
            CircularGauge {
                value: SystemStats.gpuPercent
                icon: "󰢮"
                color: Theme.secondaryColor
            }
        }

        // Show popup on hover
        onEntered: {
            performancePopup.showPopup()
        }

        onExited: {
            hideTimer.start()
        }
    }

    // Timer to delay hiding the popup
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: {
            if (!performancePopup.containsMouse) {
                performancePopup.hidePopup()
            }
        }
    }

    // Performance popup
    PerformancePopup {
        id: performancePopup
        anchorItem: root

        onContainsMouseChanged: {
            if (containsMouse) {
                hideTimer.stop()
            } else {
                hideTimer.start()
            }
        }
    }

    // Circular gauge component
    component CircularGauge: Item {
        property int value: 0
        property string icon: ""
        property color color: Theme.secondaryColor

        width: 28
        height: 28

        // Background circle
        Rectangle {
            radius: width / 2
            color: "transparent"
        }

        // Progress arc using Canvas
        Canvas {
            id: progressCanvas
            anchors.fill: parent
            antialiasing: true

            property real progress: value / 100

            onProgressChanged: requestPaint()
            onPaint: {
                const ctx = getContext("2d")
                const centerX = width / 2
                const centerY = height / 2
                const radius = (width / 2) - 3
                const startAngle = -Math.PI / 2 + (Math.PI / 4)
                const endAngle = startAngle + (2 * Math.PI * progress)

                ctx.clearRect(0, 0, width, height)
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                ctx.strokeStyle = color
                ctx.lineWidth = 1.5
                ctx.lineCap = "round"
                ctx.stroke()
            }

            Behavior on progress {
                NumberAnimation {
                    duration: 300
                    easing.type: Easing.OutQuart
                }
            }
        }

        // Center icon
        Text {
            anchors.centerIn: parent
            text: icon
            font.family: Theme.iconFont
            font.variableAxes: Theme.iconFontStyle
            font.pointSize: Theme.normalFontSize
            color: Theme.secondaryColor
        }
    }
}
