// System performance monitoring singleton for AMD/Radeon systems
// Data sources:
//   - CPU usage: /proc/stat (calculated from user+nice+system vs total ticks)
//   - Memory: /proc/meminfo (MemTotal - MemAvailable)
//   - GPU usage: /sys/class/drm/card1/device/gpu_busy_percent
//   - CPU temp: /sys/class/hwmon/hwmon3/temp1_input (k10temp driver, AMD CPU)
//   - GPU temp: /sys/class/hwmon/hwmon2/temp1_input (amdgpu driver)
// Polling interval: 1000ms

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root
    
    property int cpuPercent: 0
    property int memoryPercent: 0
    property int gpuPercent: 0

    // Temperatures, °C
    property int cpuTemp: 0
    property int gpuTemp: 0

    property int memoryUsedMB: 0
    property int memoryTotalMB: 0

    // Last 60s of samples, for the popup graphs
    property var cpuHistory: []
    property var memoryHistory: []
    property var gpuHistory: []

    property var lastCpuStats: null
    
    Timer {
        id: updateTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: root.updateStats()
    }

    FileView {
        id: cpuFile
        path: "/proc/stat"
    }

    FileView {
        id: memoryFile
        path: "/proc/meminfo"
    }

    FileView {
        id: cpuTempFile
        path: "/sys/class/hwmon/hwmon3/temp1_input"
    }

    FileView {
        id: gpuTempFile
        path: "/sys/class/hwmon/hwmon2/temp1_input"
    }

    // GPU usage: Process is more reliable than FileView for this value
    Process {
        id: gpuProcess
        command: ["cat", "/sys/class/drm/card1/device/gpu_busy_percent"]
        stdout: StdioCollector {
            onStreamFinished: {
                const text = this.text.trim()
                const value = parseInt(text)
                if (!isNaN(value)) {
                    gpuPercent = value
                }
            }
        }
    }
    
    function updateStats() {
        cpuFile.reload()
        memoryFile.reload()
        cpuTempFile.reload()
        gpuTempFile.reload()
        gpuProcess.running = true

        parseCpuStats(cpuFile.text())
        parseMemoryStats(memoryFile.text())
        parseCpuTemp(cpuTempFile.text())
        parseGpuTemp(gpuTempFile.text())
        updateHistory()
    }
    
    function parseCpuStats(data) {
        if (!data || data.length === 0) return
        
        const lines = data.split('\n')
        for (const line of lines) {
            if (line.startsWith('cpu ')) {
                const parts = line.trim().split(/\s+/)
                if (parts.length >= 5) {
                    const user = parseInt(parts[1]) || 0
                    const nice = parseInt(parts[2]) || 0
                    const system = parseInt(parts[3]) || 0
                    const idle = parseInt(parts[4]) || 0
                    
                    const total = user + nice + system + idle
                    const used = user + nice + system
                    
                    if (lastCpuStats !== null) {
                        const totalDiff = total - lastCpuStats.total
                        const usedDiff = used - lastCpuStats.used
                        
                        if (totalDiff > 0) {
                            cpuPercent = Math.round((usedDiff / totalDiff) * 100)
                        }
                    }
                    
                    lastCpuStats = { total: total, used: used }
                }
                break
            }
        }
    }
    
    function parseMemoryStats(data) {
        if (!data || data.length === 0) return
        
        const lines = data.split('\n')
        let memTotal = 0
        let memAvailable = 0
        
        for (const line of lines) {
            if (line.startsWith('MemTotal:')) {
                const match = line.match(/(\d+)/)
                if (match) memTotal = parseInt(match[1])
            } else if (line.startsWith('MemAvailable:')) {
                const match = line.match(/(\d+)/)
                if (match) memAvailable = parseInt(match[1])
            }
        }
        
        if (memTotal > 0) {
            memoryTotalMB = Math.round(memTotal / 1024)
            memoryUsedMB = Math.round((memTotal - memAvailable) / 1024)
            memoryPercent = Math.round(((memTotal - memAvailable) / memTotal) * 100)
        }
    }
    
    function parseCpuTemp(data) {
        if (!data || data.length === 0) return
        
        const value = parseInt(data.trim())
        if (!isNaN(value)) {
            cpuTemp = Math.round(value / 1000)
        }
    }
    
    function parseGpuTemp(data) {
        if (!data || data.length === 0) return
        
        const value = parseInt(data.trim())
        if (!isNaN(value)) {
            gpuTemp = Math.round(value / 1000)
        }
    }
    
    function updateHistory() {
        cpuHistory.push(cpuPercent)
        memoryHistory.push(memoryPercent)
        gpuHistory.push(gpuPercent)

        if (cpuHistory.length > 60) cpuHistory.shift()
        if (memoryHistory.length > 60) memoryHistory.shift()
        if (gpuHistory.length > 60) gpuHistory.shift()
    }
}
