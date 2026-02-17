// SystemStatus widget container
// Displays system indicators (Audio, Network, Bluetooth, Battery, Brightness)
// Positioned between PerformanceMonitor and ClockWidget in the vertical bar
// Each indicator can be enabled/disabled individually via properties

import QtQuick
import "root:/Theme"
import "data"
import "indicators"

Column {
    id: root
    spacing: Theme.normalSpacing
    width: 20
    
    // Enable/disable individual indicators
    // Set to true when hardware is available (WiFi card, Bluetooth dongle, laptop battery/brightness)
    property bool audioEnabled: true
    property bool networkEnabled: false      // Enable when WiFi card added
    property bool bluetoothEnabled: false    // Enable when Bluetooth dongle added
    property bool batteryEnabled: false      // Enable on laptop
    property bool brightnessEnabled: false   // Enable on laptop
    
    // Audio Indicator - only shows if AudioService detects audio system
    Loader {
        active: root.audioEnabled
        sourceComponent: AudioIndicator {}
        visible: status === Loader.Ready && AudioService.available
        width: 20
        height: 20
    }

    // Network Indicator - only shows if NetworkService detects WiFi
    Loader {
        active: root.networkEnabled
        sourceComponent: NetworkIndicator {}
        visible: status === Loader.Ready && NetworkService.available
        width: 20
        height: 20
    }

    // Bluetooth Indicator - only shows if BluetoothService detects Bluetooth
    Loader {
        active: root.bluetoothEnabled
        sourceComponent: BluetoothIndicator {}
        visible: status === Loader.Ready && BluetoothService.available
        width: 20
        height: 20
    }

    // Battery Indicator - only shows if BatteryService detects battery
    Loader {
        active: root.batteryEnabled
        sourceComponent: BatteryIndicator {}
        visible: status === Loader.Ready && BatteryService.available
        width: 20
        height: 20
    }

    // Brightness Indicator - only shows if BrightnessService detects brightness control
    Loader {
        active: root.brightnessEnabled
        sourceComponent: BrightnessIndicator {}
        visible: status === Loader.Ready && BrightnessService.available
        width: 20
        height: 20
    }
}
