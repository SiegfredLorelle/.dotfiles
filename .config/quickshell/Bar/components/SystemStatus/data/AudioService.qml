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
    property bool hasHeadphones: false
    property bool available: false
    
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
        const vol = Math.max(0, Math.min(100, percent)) / 100
        const process = Quickshell.createProcess()
        process.command = ["wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", vol.toFixed(2)]
        process.start()
    }
    
    function toggleMute() {
        const process = Quickshell.createProcess()
        process.command = ["wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle"]
        process.start()
        updateTimer.restart()
    }
}
