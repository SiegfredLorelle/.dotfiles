 
import QtQuick
Column {
    spacing: 4 
    
    Column {
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            id: day 
            text: Time.format("ddd")
            font.family: "JetBrainsMono Nerd Font"
            color: "#236376"
                anchors.horizontalCenter: parent.horizontalCenter
                font.pointSize: 9 
        }
        Text {
            id: date 
            text: Time.format("dd\nMM")
            font.family: "JetBrainsMono Nerd Font"
            font.pointSize: 9 
            color: "#236376"
            anchors.horizontalCenter: parent.horizontalCenter
        }
    }

    Text {
        id: timeIcon
        text: "horizontal_rule"
        font.family: "Material Symbols Rounded"
        font.pointSize: 12
        color: "#236376"
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: time 
        text: Time.format("hh\nmm\nss")
        font.family: "JetBrainsMono Nerd Font"
        font.pointSize: 9 
        color: "#236376"
        anchors.horizontalCenter: parent.horizontalCenter
    }
}

