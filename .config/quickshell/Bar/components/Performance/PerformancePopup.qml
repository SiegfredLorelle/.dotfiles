// Performance statistics popup - compact minimal design
// Shows: CPU % + temp, Memory % + usage, GPU % + temp
// No progress bars (redundant with gauge visualization)

import QtQuick
import QtQuick.Layouts
import Quickshell
import "root:/Theme"

AnimatedPopup {
    id: root

    implicitWidth: 200
    implicitHeight: 100  // Match gauge column: 3*28 + 2*8 = 100px
    leftMargin: 35

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Column {
        id: contentColumn
        anchors.fill: parent
        anchors.margins: 8
        spacing: 0  // No spacing, rows will distribute evenly

        // CPU Row
        MetricRow {
            icon: "memory"
            label: "CPU"
            value: SystemStats.cpuPercent
            detail: SystemStats.cpuTemp + "°C"
            height: parent.height / 3
        }

        // Memory Row
        MetricRow {
            icon: "storage"
            label: "RAM"
            value: SystemStats.memoryPercent
            detail: (SystemStats.memoryUsedMB / 1024).toFixed(1) + "/" +
                    (SystemStats.memoryTotalMB / 1024).toFixed(1) + " GB"
            height: parent.height / 3
        }

        // GPU Row
        MetricRow {
            icon: "󰢮"
            label: "GPU"
            value: SystemStats.gpuPercent
            detail: SystemStats.gpuTemp + "°C"
            height: parent.height / 3
        }
    }

    // Compact metric row component
    component MetricRow: RowLayout {
        property string icon
        property string label
        property int value
        property string detail

        spacing: 6
        width: parent.width

        // Icon
        Text {
            text: icon
            font.family: Theme.iconFont
            font.variableAxes: Theme.iconFontStyle
            font.pointSize: Theme.normalFontSize
            color: Theme.secondaryColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Label
        Text {
            text: label
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
            color: Theme.secondaryColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Percentage (bold)
        Text {
            text: value + "%"
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize
            font.bold: true
            color: Theme.secondaryColor
            Layout.alignment: Qt.AlignVCenter
        }

        // Spacer to push detail to the right
        Item {
            Layout.fillWidth: true
            height: 1
        }

        // Detail (temp or memory)
        Text {
            text: detail
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize - 2
            color: Theme.secondaryColor
            Layout.alignment: Qt.AlignVCenter
        }
    }
}
