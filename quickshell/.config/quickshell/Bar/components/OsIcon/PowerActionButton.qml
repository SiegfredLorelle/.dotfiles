import QtQuick
import QtQuick.Controls
import "root:/Theme"

Button {
    id: root

    property string iconName: ""
    property string tooltipText: ""

    width: 50
    height: 34
    background: Rectangle {
        color: parent.hovered ? Theme.primaryLightColor : "transparent"
        radius: 6
        opacity: parent.hovered ? 0.8 : 1.0
    }
    contentItem: Text {
        text: root.iconName
        font.family: Theme.iconFont
        font.pointSize: Theme.iconSize
        color: Theme.secondaryColor
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    ToolTip.text: root.tooltipText
    ToolTip.visible: hovered && root.tooltipText.trim().length > 0
    ToolTip.delay: 0
}
