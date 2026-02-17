pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root
    
    property bool available: false
    property bool connected: false
    property string ssid: ""
    property int signalStrength: 0
    property bool enabled: false
    
    // TODO: Implement NetworkManager integration
    // For now, stays disabled until hardware detected
    Component.onCompleted: {
        checkAvailability()
    }
    
    function checkAvailability() {
        // Will be implemented when WiFi card added
        available = false
    }
    
    function toggleWifi() {
        // TODO: Implement
    }
}
