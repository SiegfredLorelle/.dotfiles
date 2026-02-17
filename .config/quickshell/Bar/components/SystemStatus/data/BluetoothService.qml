pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root
    
    property bool available: false
    property bool enabled: false
    property bool connected: false
    property string deviceName: ""
    
    // TODO: Implement bluez integration
    Component.onCompleted: {
        checkAvailability()
    }
    
    function checkAvailability() {
        available = false
    }
    
    function toggleBluetooth() {
        // TODO: Implement
    }
}
