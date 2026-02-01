import QtQuick
import "root:/Theme"

Column {
    id: root
    spacing: Theme.barGap
    width: 36

    // Main container with mouse area
    MouseArea {
        width: parent.width
        height: gaugesColumn.height
        hoverEnabled: true

        Column {
            id: gaugesColumn
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: Theme.barGap

            // CPU Gauge
            CircularGauge {
                value: SystemStats.cpuPercent
                icon: "󰻠"
                color: Theme.secondaryColor
            }

            // Memory Gauge
            CircularGauge {
                value: SystemStats.memoryPercent
                icon: "󰍛"
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

        width: 32
        height: 32

        // Background circle
        Rectangle {
            anchors.fill: parent
            radius: width / 2
            color: "transparent"
            border.color: Theme.secondaryColorOpaqued
            border.width: 2
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
                const startAngle = -Math.PI / 2
                const endAngle = startAngle + (2 * Math.PI * progress)

                ctx.clearRect(0, 0, width, height)
                ctx.beginPath()
                ctx.arc(centerX, centerY, radius, startAngle, endAngle)
                ctx.strokeStyle = color
                ctx.lineWidth = 3
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
            font.pointSize: Theme.normalFontSize - 2
            color: color
        }
    }
}
