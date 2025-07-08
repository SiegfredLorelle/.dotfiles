import QtQuick
import QtQuick.Controls
import Quickshell

PopupWindow {
    id: root

    property real animationOpacity: 0.0
    property real animationSlideX: -width * 0.8
    property bool isAnimating: false
    property real leftMargin: 0
    property alias containsMouse: mouseArea.containsMouse
    property Item anchorItem

    default property alias contentData: animatedItem.data

    anchor {
        item: anchorItem
    }

    color: "transparent"
    visible: false

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
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true

        Item {
            id: animatedItem
            anchors.fill: parent
            anchors.leftMargin: root.leftMargin
            opacity: root.animationOpacity
            transform: Translate {
                x: root.animationSlideX
            }
        }
    }
}
