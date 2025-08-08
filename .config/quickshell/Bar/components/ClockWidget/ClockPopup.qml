import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/Theme"

AnimatedPopup {
    id: root

    implicitWidth: 300
    implicitHeight: 250
    leftMargin: 35

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Column {
        anchors.fill: parent
        anchors.margins: 10
        spacing: 10

        Item {
            anchors.left: parent.left
            anchors.right: parent.right
            height: Math.max(monthText.height, leftArrow.height, rightArrow.height)
            opacity: root.animationOpacity

            Text {
                id: monthText
                text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
                font.family: Theme.primaryFont
                font.pointSize: Theme.normalFontSize
                color: Theme.secondaryColor
                anchors.left: parent.left
                anchors.leftMargin: 6
                anchors.verticalCenter: parent.verticalCenter
                horizontalAlignment: Text.AlignLeft
            }

            Row {
                anchors.right: parent.right
                anchors.rightMargin: -6
                anchors.verticalCenter: parent.verticalCenter

                Button {
                    id: leftArrow
                    text: "arrow_left"
                    onClicked: calendar.currentDate = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() - 1, 1)
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: Theme.secondaryColor
                        font.pointSize: Theme.iconSize
                        font.family: Theme.iconFont
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }
                }

                Button {
                    id: rightArrow
                    text: "arrow_right"
                    onClicked: calendar.currentDate = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 1)
                    background: Rectangle {
                        color: "transparent"
                    }
                    contentItem: Text {
                        text: parent.text
                        color: Theme.secondaryColor
                        font.pointSize: Theme.iconSize
                        font.family: Theme.iconFont
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        anchors.fill: parent
                    }
                }
            }
        }

        Grid {
            id: calendar
            anchors.horizontalCenter: parent.horizontalCenter
            columns: 7
            spacing: 2

            property date currentDate: new Date()
            property date today: new Date()

            opacity: root.animationOpacity
            transform: Translate {
                x: root.animationSlideX * 0.2
            }

            Repeater {
                model: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
                Rectangle {
                    width: 35
                    height: 25
                    color: "transparent"
                    Text {
                        anchors.centerIn: parent
                        text: modelData
                        font.family: Theme.primaryFont
                        font.pointSize: Theme.smallFontSize || Theme.normalFontSize - 2
                        color: Theme.secondaryColor
                        font.bold: true
                    }
                }
            }

            Repeater {
                model: 42
                Rectangle {
                    width: 30
                    height: 25
                    color: {
                        if (dayNumber === calendar.today.getDate() && 
                            monthOffset === 0 && 
                            calendar.currentDate.getMonth() === calendar.today.getMonth() && 
                            calendar.currentDate.getFullYear() === calendar.today.getFullYear()) {
                            return Theme.primaryLightColor
                        }
                        return "transparent"
                    }
                    radius: 4

                    property int dayNumber: {
                        var firstDay = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth(), 1)
                        var startDay = firstDay.getDay()
                        var dayInMonth = index - startDay + 1

                        if (index < startDay) {
                            var prevMonth = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() - 1, 0)
                            return prevMonth.getDate() - (startDay - index - 1)
                        } else if (dayInMonth <= new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 0).getDate()) {
                            return dayInMonth
                        } else {
                            return dayInMonth - new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 0).getDate()
                        }
                    }

                    property int monthOffset: {
                        var firstDay = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth(), 1)
                        var startDay = firstDay.getDay()
                        var dayInMonth = index - startDay + 1

                        if (index < startDay) return -1
                        else if (dayInMonth <= new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 0).getDate()) return 0
                        else return 1
                    }

                    Text {
                        anchors.centerIn: parent
                        text: parent.dayNumber
                        font.family: Theme.primaryFont
                        font.pointSize: Theme.smallFontSize || Theme.normalFontSize - 2
                        color: {
                            if (parent.monthOffset !== 0) {
                                return Theme.secondaryLighterColor
                            }
                            return Theme.secondaryColor
                        }
                    }
                }
            }
        }
    }
}
