import QtQuick
import "root:/Theme"
import "../data"

Rectangle {
    id: root
    width: 20
    height: 20
    color: "transparent"
    visible: BluetoothService.available
    
    Text {
        anchors.centerIn: parent
        text: BluetoothService.enabled ? "bluetooth" : "bluetooth_disabled"
        font.family: Theme.iconFont
        font.variableAxes: Theme.iconFontStyle
        font.pointSize: Theme.normalFontSize
        color: BluetoothService.enabled ? Theme.secondaryColor : Theme.opaqueSecondaryColor
    }
    
    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: BluetoothService.toggleBluetooth()
        onEntered: bluetoothPopup.showPopup()
        onExited: hideTimer.start()
    }
    
    Timer {
        id: hideTimer
        interval: 200
        onTriggered: if (!bluetoothPopup.containsMouse) bluetoothPopup.hidePopup()
    }
    
    BluetoothPopup {
        id: bluetoothPopup
        anchorItem: root
        onContainsMouseChanged: {
            if (containsMouse) hideTimer.stop()
            else hideTimer.start()
        }
    }
}
