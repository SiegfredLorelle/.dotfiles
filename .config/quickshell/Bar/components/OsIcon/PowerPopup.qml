import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "root:/Theme"

PopupWindow {
    id: root
    
    property Item anchorItem
    property alias containsMouse: powerMouseArea.containsMouse
    
    // Animation properties
    property real animationOpacity: 0.0
    property real animationSlideX: -width * 0.8  // Start from left, mostly hidden
    property bool isAnimating: false
    property bool newsExpanded: false
    property var newsItems: []
    
    anchor {
        item: anchorItem
    }
    
    width: 250 + 8 * 2
    height: newsExpanded ? 300 : 80
    color: "transparent"
    visible: false
    
    // Process components for system commands (using the pattern from the reference code)
    Process {
        id: logoutProcess
        command: ["sh", "-c", "hyprctl dispatch exit"]
        running: false
        onExited: {
            running = false
            console.log("Logout command executed")
        }
    }
    
    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
        running: false
        onExited: {
            running = false
            console.log("Shutdown command executed")
        }
    }
    
    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
        running: false
        onExited: {
            running = false
            console.log("Reboot command executed")
        }
    }
    
    Process {
        id: lockProcess
        command: ["sh", "-c", "hyprlock"]
        running: false
        onExited: {
            running = false
            console.log("Lock command executed")
        }
    }
    
    // Public methods for showing/hiding with animation
    function showPopup() {
        if (isAnimating && visible) return
        
        visible = true
        isAnimating = true
        showAnimation.start()
        fetchArchNews()
    }
    
    function hidePopup() {
        if (isAnimating && !visible) return
        
        isAnimating = true
        hideAnimation.start()
        newsExpanded = false
    }
    
    function fetchArchNews() {
        // Simulate fetching news - replace with actual RSS/API call
        newsItems = [
            {
                title: "Arch Linux Update 2024.12.01",
                date: "2024-12-01",
                summary: "Latest kernel updates and package improvements..."
            },
            {
                title: "Security Advisory: OpenSSL Update",
                date: "2024-11-28",
                summary: "Important security fixes for OpenSSL package..."
            },
            {
                title: "KDE Plasma 6.2 Available",
                date: "2024-11-25",
                summary: "New features and performance improvements in KDE..."
            }
        ]
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
        id: powerMouseArea
        anchors.fill: parent
        hoverEnabled: true
        
        Item {
            anchors.fill: parent
            anchors.leftMargin: 34.3
            
            // Apply slide animation to the entire container
            opacity: root.animationOpacity
            transform: Translate {
                x: root.animationSlideX
            }
            
            // Glass effects background
            GlassEffects {
                anchors.fill: parent
                rightRadius: true  // Only right side has radius
                showBorder: false
                borderRadius: Theme.borderRadius
            }
            
            // Main content column
            Column {
                anchors.fill: parent
                anchors.margins: 8
                spacing: 6
                
                // Horizontal layout for power buttons
                Row {
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: 6
                    
                    // Lock button
                    Button {
                        id: lockButton
                        width: 50
                        height: 34
                        
                        background: Rectangle {
                            color: parent.hovered ? Theme.primaryLightColor : "transparent"
                            radius: 6
                            opacity: parent.hovered ? 0.8 : 1.0
                            // Removed Behavior - instant color change
                        }
                        
                        contentItem: Text {
                            text: "󰌾"  // Lock icon
                            font.family: Theme.iconFont
                            font.pointSize: Theme.normalFontSize
                            color: Theme.secondaryColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            lockProcess.running = true
                            root.hidePopup()
                        }
                        
                        ToolTip.text: "Lock Screen"
                        ToolTip.visible: hovered
                        ToolTip.delay: 0  // Instant tooltip
                    }
                    
                    // Logout button
                    Button {
                        id: logoutButton
                        width: 50
                        height: 34
                        
                        background: Rectangle {
                            color: parent.hovered ? Theme.primaryLightColor : "transparent"
                            radius: 6
                            opacity: parent.hovered ? 0.8 : 1.0
                            // Removed Behavior - instant color change
                        }
                        
                        contentItem: Text {
                            text: "󰍃"  // Logout icon
                            font.family: Theme.iconFont
                            font.pointSize: Theme.normalFontSize
                            color: Theme.secondaryColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            logoutProcess.running = true
                            root.hidePopup()
                        }
                        
                        ToolTip.text: "Logout"
                        ToolTip.visible: hovered
                        ToolTip.delay: 0  // Instant tooltip
                    }
                    
                    // Shutdown button
                    Button {
                        id: shutdownButton
                        width: 50
                        height: 34
                        
                        background: Rectangle {
                            color: parent.hovered ? Theme.primaryLightColor : "transparent"
                            radius: 6
                            opacity: parent.hovered ? 0.8 : 1.0
                            // Removed Behavior - instant color change
                        }
                        
                        contentItem: Text {
                            text: "󰐥"  // Shutdown icon
                            font.family: Theme.iconFont
                            font.pointSize: Theme.normalFontSize
                            color: Theme.secondaryColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            shutdownProcess.running = true
                            root.hidePopup()
                        }
                        
                        ToolTip.text: "Shutdown"
                        ToolTip.visible: hovered
                        ToolTip.delay: 0  // Instant tooltip
                    }
                    
                    // Reboot button
                    Button {
                        id: rebootButton
                        width: 50
                        height: 34
                        
                        background: Rectangle {
                            color: parent.hovered ? Theme.primaryLightColor : "transparent"
                            radius: 6
                            opacity: parent.hovered ? 0.8 : 1.0
                            // Removed Behavior - instant color change
                        }
                        
                        contentItem: Text {
                            text: "󰜉"  // Reboot icon
                            font.family: Theme.iconFont
                            font.pointSize: Theme.normalFontSize
                            color: Theme.secondaryColor
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        onClicked: {
                            rebootProcess.running = true
                            root.hidePopup()
                        }
                        
                        ToolTip.text: "Reboot"
                        ToolTip.visible: hovered
                        ToolTip.delay: 0  // Instant tooltip
                    }
                }
                
                // News section toggle button
                Button {
                    id: newsToggleButton
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: 215
                    height: 30
                    
                    background: Rectangle {
                        color: parent.hovered ? Theme.primaryLightColor : "transparent"
                        radius: 6
                        opacity: parent.hovered ? 0.8 : 1.0
                        // Removed Behavior - instant color change
                    }
                    
                    contentItem: Row {
                        anchors.centerIn: parent
                        spacing: 4
                        
                        Text {
                            text: "󰎕"  // News icon
                            font.family: Theme.iconFont
                            font.pointSize: Theme.normalFontSize * 0.8
                            color: Theme.secondaryColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: "Arch News"
                            font.family: Theme.textFont
                            font.pointSize: Theme.normalFontSize * 0.7
                            color: Theme.secondaryColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        
                        Text {
                            text: newsExpanded ? "▲" : "▼"
                            font.family: Theme.textFont
                            font.pointSize: Theme.normalFontSize * 0.6
                            color: Theme.secondaryColor
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }
                    
                    onClicked: {
                        newsExpanded = !newsExpanded
                    }
                    
                    ToolTip.text: newsExpanded ? "Hide Arch News" : "Show Arch News"
                    ToolTip.visible: hovered
                    ToolTip.delay: 0  // Instant tooltip
                }
                
                // News items list
                ScrollView {
                    id: newsScrollView
                    width: parent.width
                    height: newsExpanded ? 200 : 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: newsExpanded
                    clip: true
                    
                    Behavior on height {
                        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
                    }
                    
                    Column {
                        width: newsScrollView.width
                        spacing: 4
                        
                        Repeater {
                            model: newsItems
                            delegate: Rectangle {
                                width: parent.width
                                height: newsItemColumn.height + 8
                                color: newsItemMouseArea.containsMouse ? Theme.primaryLightColor : "transparent"
                                radius: 4
                                // Removed Behavior - instant color change like news items
                                
                                MouseArea {
                                    id: newsItemMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true
                                    
                                    onClicked: {
                                        // Handle news item click
                                        console.log("News item clicked:", modelData.title)
                                    }
                                }
                                
                                Column {
                                    id: newsItemColumn
                                    anchors.left: parent.left
                                    anchors.right: parent.right
                                    anchors.top: parent.top
                                    anchors.margins: 4
                                    spacing: 2
                                    
                                    Text {
                                        text: modelData.title
                                        font.family: Theme.textFont
                                        font.pointSize: Theme.normalFontSize * 0.7
                                        font.weight: Font.Medium
                                        color: Theme.secondaryColor
                                        width: parent.width
                                        wrapMode: Text.WordWrap
                                    }
                                    
                                    Text {
                                        text: modelData.date
                                        font.family: Theme.textFont
                                        font.pointSize: Theme.normalFontSize * 0.6
                                        color: Theme.secondaryColor
                                        opacity: 0.7
                                    }
                                    
                                    Text {
                                        text: modelData.summary
                                        font.family: Theme.textFont
                                        font.pointSize: Theme.normalFontSize * 0.6
                                        color: Theme.secondaryColor
                                        opacity: 0.8
                                        width: parent.width
                                        wrapMode: Text.WordWrap
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
