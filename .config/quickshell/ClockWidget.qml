
import QtQuick
Column {
    spacing: 8 
    Text {
        id: icon
        text: "calendar_month"
        font.family: "Material Symbols Rounded"
        font.pointSize: 16
        anchors.horizontalCenter: parent.horizontalCenter

    }
    Text {
        id: text
        text: Time.format("hh\nmm")
        anchors.horizontalCenter: parent.horizontalCenter
}


}

