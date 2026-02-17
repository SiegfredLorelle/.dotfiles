pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell

Singleton {
    id: root
    
    property bool available: false
    property int level: 0
    property bool charging: false
    property int timeRemaining: 0
    
    // TODO: Implement upower integration
    Component.onCompleted: {
        checkAvailability()
    }
    
    function checkAvailability() {
        // Check for battery at /sys/class/power_supply/BAT0
        available = false
    }
}
