import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/Theme"

PopupWindow {
    id: root
    
    property Item anchorItem
    property alias visible: root.visible
    
    anchor {
        item: anchorItem
        adjustment: Quickshell.Anchor.Right | Quickshell.Anchor.Top
    }
    
    width: 300
    height: 250 
    color: "transparent" 

    // Expose mouse area for hover detection
    readonly property alias containsMouse: calendarMouseArea.containsMouse
    
    MouseArea {
        id: calendarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        Rectangle {
            anchors.fill: parent
            color: Theme.primaryColor
            radius: 8
            anchors.leftMargin: 35
            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                
                // Calendar header
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 20
                    
                    Button {
                        text: "‹"
                        onClicked: calendar.currentDate = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() - 1, 1)
                        background: Rectangle {
                            color: "transparent"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: Theme.secondaryColor
                            font.pointSize: Theme.normalFontSize
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                    
                    Text {
                        text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
                        font.family: Theme.primaryFont
                        font.pointSize: Theme.normalFontSize
                        color: Theme.secondaryColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                    
                    Button {
                        text: "›"
                        onClicked: calendar.currentDate = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 1)
                        background: Rectangle {
                            color: "transparent"
                        }
                        contentItem: Text {
                            text: parent.text
                            color: Theme.secondaryColor
                            font.pointSize: Theme.normalFontSize
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
                
                // Calendar grid
                Grid {
                    id: calendar
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 7
                    spacing: 2
                    
                    property date currentDate: new Date()
                    property date today: new Date()
                    
                    // Day headers
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
                    
                    // Calendar days
                    Repeater {
                        model: 42 // 6 weeks * 7 days
                        Rectangle {
                            width: 30
                            height: 25
                            color: {
                                if (dayNumber === calendar.today.getDate() && 
                                    monthOffset === 0 && 
                                    calendar.currentDate.getFullYear() === calendar.today.getFullYear()) {
                                    return Theme.primaryLightColor
                                }
                                return mouseArea.containsMouse ? (Theme.primaryLightColor) : "transparent"
                            }
                            radius: 4
                            
                            property int dayNumber: {
                                var firstDay = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth(), 1)
                                var startDay = firstDay.getDay()
                                var dayInMonth = index - startDay + 1
                                
                                if (index < startDay) {
                                    // Previous month
                                    var prevMonth = new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() - 1, 0)
                                    return prevMonth.getDate() - (startDay - index - 1)
                                } else if (dayInMonth <= new Date(calendar.currentDate.getFullYear(), calendar.currentDate.getMonth() + 1, 0).getDate()) {
                                    // Current month
                                    return dayInMonth
                                } else {
                                    // Next month
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
                                        return Theme.tertiaryColor || Theme.secondaryLighterColor 
                                    }
                                    if (parent.dayNumber === calendar.today.getDate() && 
                                        parent.monthOffset === 0 && 
                                        calendar.currentDate.getFullYear() === calendar.today.getFullYear()) {
                                        return Theme.secondaryColor 
                                    }
                                    return Theme.secondaryColor
                                }
                            }
                            
                            MouseArea {
                                id: mouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                            }
                        }
                    }
                }
            }
        }
    }
}
