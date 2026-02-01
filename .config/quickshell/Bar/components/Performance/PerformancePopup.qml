// Performance statistics popup - shows on hover over PerformanceMonitor
// Displays: CPU % + temp, Memory % + usage in MB, GPU % + temp
// Uses GlassEffects for background styling matching the bar theme

import QtQuick
import Quickshell
import "root:/Theme"

AnimatedPopup {
    id: root

    implicitWidth: 280
    implicitHeight: 220
    leftMargin: 35

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 10

        // Header
        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 8

            Text {
                text: "󰓅"
                font.family: Theme.iconFont
                font.pointSize: Theme.mediumFontSize
                color: Theme.secondaryColor
            }

            Text {
                text: "PERFORMANCE"
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize
                font.bold: true
                color: Theme.secondaryColor
            }
        }

        // CPU Section
        PerformanceStatRow {
            icon: "󰻠"
            label: "CPU"
            percent: SystemStats.cpuPercent
            color: Theme.secondaryColor
            temp: SystemStats.cpuTemp
        }

        // Memory Section
        PerformanceStatRow {
            icon: "󰍛"
            label: "RAM"
            percent: SystemStats.memoryPercent
            color: Theme.secondaryColor
            detail: SystemStats.memoryUsedMB + " / " + SystemStats.memoryTotalMB + " MB"
        }

        // GPU Section
        PerformanceStatRow {
            icon: "󰢮"
            label: "GPU"
            percent: SystemStats.gpuPercent
            color: Theme.secondaryColor
            temp: SystemStats.gpuTemp
        }
    }

    // Reusable component for each stat row
    component PerformanceStatRow: Column {
        property string icon
        property string label
        property int percent
        property color color
        property int temp: 0
        property string detail: ""

        spacing: 4
        width: parent.width

        // Label row
        Row {
            spacing: 6

            Text {
                text: icon
                font.family: Theme.iconFont
                font.pointSize: Theme.normalFontSize
                color: parent.parent.color
            }

            Text {
                text: label
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize
                color: Theme.secondaryColor
            }

            Item {
                width: parent.parent.width - parent.children[0].width - parent.children[1].width - parent.children[3].width - 18
                height: 1
            }

            Text {
                text: percent + "%"
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize
                font.bold: true
                color: parent.parent.color
            }
        }

        // Progress bar
        Rectangle {
            width: parent.width
            height: 8
            radius: 4
            color: Theme.secondaryColorOpaqued

            Rectangle {
                width: parent.width * (percent / 100)
                height: parent.height
                radius: parent.radius
                color: parent.parent.color

                Behavior on width {
                    NumberAnimation {
                        duration: 300
                        easing.type: Easing.OutQuart
                    }
                }
            }
        }

        // Detail row (temp or memory detail)
        Row {
            spacing: 6
            visible: temp > 0 || detail !== ""

            Text {
                text: temp > 0 ? "󰔏 " + temp + "°C" : detail
                font.family: temp > 0 ? Theme.iconFont : Theme.primaryFont
                font.pointSize: Theme.normalFontSize - 2
                color: Theme.secondaryLighterColor
            }
        }
    }
}
