pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root
    
    property bool available: false
    property int brightness: 0
    property int maxBrightness: 100
    
    // TODO: Implement brightnessctl integration
    Component.onCompleted: {
        checkAvailability()
    }
    
    function checkAvailability() {
        available = false
    }
    
    function setBrightness(value) {
        // TODO: Implement
    }
}
