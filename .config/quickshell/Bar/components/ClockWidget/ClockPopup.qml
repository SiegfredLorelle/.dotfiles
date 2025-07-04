import QtQuick
import QtQuick.Controls
import Quickshell
import "root:/Theme"

PopupWindow {
    id: root
    
    property Item anchorItem
    property alias containsMouse: calendarMouseArea.containsMouse
    
    // Animation properties
    property real animationOpacity: 0.0
    property real animationSlideX: -width * 0.8  // Start from left, mostly hidden
    property bool isAnimating: false
    
    anchor {
        item: anchorItem
        adjustment: Quickshell.Anchor.Right | Quickshell.Anchor.Top
    }
    
    width: 300
    height: 250 
    color: "transparent"
    visible: false
    
    // Public methods for showing/hiding with animation
    function showPopup() {
        if (isAnimating && visible) return
        
        visible = true
        isAnimating = true
        showAnimation.start()
    }
    
    function hidePopup() {
        if (isAnimating && !visible) return
        
        isAnimating = true
        hideAnimation.start()
    }
    
    // Show animation
    ParallelAnimation {
        id: showAnimation
        
        NumberAnimation {
            target: root
            property: "animationOpacity"
            from: 0.0
            to: 1.0
            duration: 250
            easing.type: Easing.OutCubic
        }
        
        NumberAnimation {
            target: root
            property: "animationSlideX"
            from: -root.width * 0.8
            to: 0
            duration: 300
            easing.type: Easing.OutQuart
        }
        
        onFinished: {
            isAnimating = false
        }
    }
    
    // Hide animation
    ParallelAnimation {
        id: hideAnimation
        
        NumberAnimation {
            target: root
            property: "animationOpacity"
            from: 1.0
            to: 0.0
            duration: 200
            easing.type: Easing.InCubic
        }
        
        NumberAnimation {
            target: root
            property: "animationSlideX"
            from: 0
            to: -root.width * 0.6
            duration: 200
            easing.type: Easing.InQuart
        }
        
        onFinished: {
            visible = false
            isAnimating = false
        }
    }
    
    MouseArea {
        id: calendarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        Rectangle {
            anchors.fill: parent
            color: Theme.primaryColor
            radius: 8
            anchors.leftMargin: 35
            
            // Apply animation properties
            opacity: root.animationOpacity
            transform: Translate {
                x: root.animationSlideX
            }
            
            // Add subtle border and background shadow effect
            border.width: 1
            border.color: Qt.rgba(0, 0, 0, 0.1 * root.animationOpacity)
            
            // Simple shadow using a background rectangle
            Rectangle {
                anchors.fill: parent
                anchors.topMargin: 2
                anchors.leftMargin: 2
                color: Qt.rgba(0, 0, 0, 0.1 * root.animationOpacity)
                radius: parent.radius
                z: -1
                transform: Translate {
                    x: root.animationSlideX
                }
            }
            
            Column {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10
                
                // Calendar header
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    opacity: root.animationOpacity
                    
                    Button {
                        width: 40  // Set explicit width
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
                            anchors.fill: parent  // Make text fill entire button area
                        }
                    }
                    
                    Text {
                        text: Qt.formatDate(calendar.currentDate, "MMMM yyyy")
                        font.family: Theme.primaryFont
                        font.pointSize: Theme.normalFontSize
                        color: Theme.secondaryColor
                        anchors.verticalCenter: parent.verticalCenter
                        width: 125  // Set consistent width for month/year text
                        horizontalAlignment: Text.AlignHCenter
                    }
                    
                    Button {
                        width: 40  // Set explicit width
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
                            anchors.fill: parent  // Make text fill entire button area
                        }
                    }
                }
                
                // Calendar grid with subtle slide effect
                Grid {
                    id: calendar
                    anchors.horizontalCenter: parent.horizontalCenter
                    columns: 7
                    spacing: 2
                    
                    property date currentDate: new Date()
                    property date today: new Date()
                    
                    // Slight delay for calendar grid to create staggered effect
                    opacity: root.animationOpacity
                    transform: Translate {
                        x: root.animationSlideX * 0.2  // Subtle secondary motion
                    }
                    
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
                                return "transparent"
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
                        }
                    }
                }
            }
        }
    }
}
