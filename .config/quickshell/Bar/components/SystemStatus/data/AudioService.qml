// Audio monitoring singleton using pipewire/wireplumber
// Data sources:
//   - Volume/mute: wpctl (wireplumber)
// Polling interval: 500ms (audio changes frequently)
// Pattern: pragma Singleton + Singleton type

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    // Audio properties
    property int volume: 0
    property bool isMuted: false
    property bool available: false
    
    // Properties for commands
    property real targetVolume: 0.5
    property bool shouldSetVolume: false
    property bool shouldToggleMute: false
    
    // Timer for periodic updates
    Timer {
        id: updateTimer
        interval: 500
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateAudio()
    }
    
    // Process for getting volume
    Process {
        id: volumeProcess
        command: ["wpctl", "get-volume", "@DEFAULT_AUDIO_SINK@"]
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()
                parseVolume(text)
            }
        }
    }
    
    // Process for setting volume
    Process {
        id: setVolumeProcess
        running: root.shouldSetVolume
        command: ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", root.targetVolume.toFixed(2)]
        onRunningChanged: {
            if (!running) {
                root.shouldSetVolume = false
                updateTimer.restart()
            }
        }
    }
    
    // Process for toggling mute
    Process {
        id: toggleMuteProcess
        running: root.shouldToggleMute
        command: ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        onRunningChanged: {
            if (!running) {
                root.shouldToggleMute = false
                updateTimer.restart()
            }
        }
    }
    
    function updateAudio() {
        volumeProcess.running = true
    }
    
    function parseVolume(data) {
        if (!data || data.length === 0) {
            available = false
            return
        }
        
        available = true
        
        // Parse: "Volume: 0.65" or "Volume: 0.65 [MUTED]"
        const match = data.match(/Volume:\s*([\d.]+)(?:\s*\[MUTED\])?/)
        if (match) {
            const vol = parseFloat(match[1])
            volume = Math.round(vol * 100)
            isMuted = data.includes("[MUTED]")
        }
    }
    
    function setVolume(percent) {
        targetVolume = Math.max(0, Math.min(100, percent)) / 100
        shouldSetVolume = true
    }
    
    function toggleMute() {
        shouldToggleMute = true
    }
}
