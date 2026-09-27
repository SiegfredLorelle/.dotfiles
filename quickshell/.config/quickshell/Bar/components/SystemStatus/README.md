# SystemStatus Widget

System status indicators for the Quickshell bar.

## Position

Located between PerformanceMonitor and ClockWidget in the vertical bar.

## Indicators

- **Audio** (enabled) - Volume icon with mute toggle and scroll adjustment
- **Network** (disabled) - WiFi status (enable when WiFi card installed)
- **Bluetooth** (disabled) - Bluetooth status (enable when dongle installed)
- **Battery** (disabled) - Battery level (enable on laptop)
- **Brightness** (disabled) - Screen brightness (enable on laptop)

## Enabling Indicators

Edit `SystemStatus.qml` and change the enabled properties:

```qml
property bool audioEnabled: true
property bool networkEnabled: true  // Enable this when WiFi is available
```

## Interactions

### Audio Indicator
- **Click**: Toggle mute/unmute
- **Scroll**: Adjust volume up/down (5% increments)
- **Hover**: Show popup with volume percentage and visual bar

### Other Indicators
Similar interactions will be implemented when the services are fully developed.

## Dependencies

- Audio: `wireplumber` / `wpctl`
- Network: `NetworkManager` (planned)
- Bluetooth: `bluez` (planned)
- Battery: `upower` (planned)
- Brightness: `brightnessctl` (planned)

## Architecture

```
SystemStatus/
├── SystemStatus.qml          # Container component
├── data/                     # Singleton data services
│   ├── AudioService.qml
│   ├── NetworkService.qml
│   ├── BluetoothService.qml
│   ├── BatteryService.qml
│   └── BrightnessService.qml
└── indicators/               # Visual components
    ├── AudioIndicator.qml
    ├── AudioPopup.qml
    ├── NetworkIndicator.qml
    ├── NetworkPopup.qml
    └── ... (similar for others)
```

Each indicator follows the pattern:
1. **Service** (Singleton) - Polls system state every 500-1000ms
2. **Indicator** - Visual component with interactions
3. **Popup** - Detailed info on hover
