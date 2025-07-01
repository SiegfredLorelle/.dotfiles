import QtQuick
import "root:/Theme"

Column {
    spacing: 4 
    
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: day 
            text: Time.format("ddd")
            font.family: Theme.primaryFont
            color: Theme.secondaryColor
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: Theme.normalFontSize 
        }
        Text {
            id: date 
            text: Time.format("dd\nMM")
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize 
            color: Theme.secondaryColor
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: timeIcon
        text: "―"
        font.family: Theme.primaryFont 
        font.pointSize: Theme.largeFontSize
        color: Theme.secondaryColor
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: time 
        text: Time.format("hh\nmm\nss")
        font.family: Theme.primaryFont
        font.pointSize: Theme.normalFontSize 
        color: Theme.secondaryColor
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

