import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io
import "root:/Theme"

AnimatedPopup {
    id: root

    implicitWidth: 250 + 8 * 2
    implicitHeight: newsExpanded ? 300 : 90
    leftMargin: 34.3

    property bool newsExpanded: false
    property var newsItems: []
    property string lastFetchTime: "Never"
    property string rawTimestamp: ""
    property bool fetchingNews: false
    property string errorMessage: ""
    property bool usingCache: false

    Process {
        id: logoutProcess
        command: ["sh", "-c", "hyprctl dispatch exit"]
        running: false
        onExited: {
            running = false
            console.log("Logout command executed")
        }
    }

    Process {
        id: shutdownProcess
        command: ["systemctl", "poweroff"]
        running: false
        onExited: {
            running = false
            console.log("Shutdown command executed")
        }
    }

    Process {
        id: rebootProcess
        command: ["systemctl", "reboot"]
        running: false
        onExited: {
            running = false
            console.log("Reboot command executed")
        }
    }

    Process {
        id: lockProcess
        command: ["sh", "-c", "hyprlock"]
        running: false
        onExited: {
            running = false
            console.log("Lock command executed")
        }
    }

    Process {
        id: newsProcess
        command: [Quickshell.env("HOME") + "/.config/quickshell/scripts/fetch-arch-news.py"]
        running: false
        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const response = JSON.parse(this.text)
                    if (response.items) {
                        newsItems = response.items
                        if (response.timestamp) {
                            rawTimestamp = response.timestamp
                            updateLastFetchTime(response.timestamp)
                        }
                        writeCache(response)
                        errorMessage = ""
                        usingCache = false
                    } else if (response.error) {
                        handleFetchError(response.error)
                    }
                } catch (e) {
                    console.log("Failed to parse news JSON:", e)
                    handleFetchError("Failed to parse news data")
                }
            }
        }
        stderr: StdioCollector {
            onStreamFinished: {
                console.log("News fetch error:", this.text)
                if (this.text.length > 0) {
                    handleFetchError(this.text.trim())
                }
            }
        }
        onExited: {
            running = false
            fetchingNews = false
        }
    }

    Process {
        id: openUrlProcess
        command: ["xdg-open", ""]
        running: false
        onExited: {
            running = false
        }
    }

    FileView {
        id: cacheFile
        path: Quickshell.env("HOME") + "/.cache/quickshell/arch-news.json"
        blockWrites: false
        onLoaded: {
            console.log("Cache file loaded")
        }
        onLoadFailed: function(error) {
            console.log("Failed to load cache:", error.code, error.message)
        }
        onSaved: {
            console.log("Cache saved successfully")
        }
        onSaveFailed: function(error) {
            console.log("Failed to save cache:", error.code, error.message)
        }
    }

    function fetchArchNews(forceRefresh = false) {
        if (fetchingNews) return

        const cacheData = readCache()

        if (!forceRefresh && cacheData && !isCacheStale(cacheData.timestamp)) {
            loadNewsFromCache(cacheData)
            return
        }

        usingCache = false
        fetchingNews = true
        errorMessage = ""
        newsProcess.running = true
    }

    function openUrl(url) {
        openUrlProcess.command = ["xdg-open", url]
        openUrlProcess.running = true
    }

    function updateLastFetchTime(timestamp) {
        try {
            const fetchDate = new Date(timestamp)
            const now = new Date()
            const diffMs = now - fetchDate
            const diffMins = Math.floor(diffMs / 60000)
            const diffHours = Math.floor(diffMins / 60)
            const diffDays = Math.floor(diffHours / 24)

            if (diffMins < 1) {
                lastFetchTime = "Just now"
            } else if (diffMins < 60) {
                lastFetchTime = diffMins + " min" + (diffMins !== 1 ? "s" : "") + " ago"
            } else if (diffHours < 24) {
                lastFetchTime = diffHours + " hour" + (diffHours !== 1 ? "s" : "") + " ago"
            } else {
                lastFetchTime = diffDays + " day" + (diffDays !== 1 ? "s" : "") + " ago"
            }
        } catch (e) {
            console.log("Failed to update fetch time:", e)
            lastFetchTime = "Unknown"
        }
    }

    function isCacheStale(cacheTimestamp) {
        try {
            const cacheDate = new Date(cacheTimestamp)
            const now = new Date()
            const diffMs = now - cacheDate
            return diffMs > 3600000
        } catch (e) {
            console.log("Failed to check cache staleness:", e)
            return true
        }
    }

    function readCache() {
        try {
            const content = cacheFile.text()

            if (!content || content.length === 0) {
                return null
            }

            const parsed = JSON.parse(content)
            if (!parsed.items || !Array.isArray(parsed.items)) {
                return null
            }

            return parsed
        } catch (e) {
            console.log("Failed to read/parse cache:", e)
            return null
        }
    }

    function writeCache(data) {
        try {
            const jsonString = JSON.stringify(data, null, 2)
            cacheFile.setText(jsonString)
        } catch (e) {
            console.log("Failed to write cache:", e)
        }
    }

    function loadNewsFromCache(cacheData) {
        newsItems = cacheData.items
        if (cacheData.timestamp) {
            rawTimestamp = cacheData.timestamp
            updateLastFetchTime(cacheData.timestamp)
        }
        usingCache = true
        errorMessage = ""
    }

    function handleFetchError(errorMsg) {
        errorMessage = errorMsg

        const staleCache = readCache()
        if (staleCache) {
            console.log("Using stale cache due to fetch error")
            loadNewsFromCache(staleCache)
            errorMessage = errorMsg + " (using stale cache)"
        }

        fetchingNews = false
    }

    function formatNewsDate(dateString) {
        try {
            const date = new Date(dateString)
            const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun",
                           "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            const day = date.getDate()
            const month = months[date.getMonth()]
            const year = date.getFullYear()
            return day + " " + month + " " + year
        } catch (e) {
            console.log("Failed to format date:", e)
            return dateString
        }
    }

    onVisibleChanged: {
        if (visible) fetchArchNews()
        else newsExpanded = false
    }

    GlassEffects {
        anchors.fill: parent
        rightRadius: true
        showBorder: false
        borderRadius: Theme.borderRadius
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 6

        Row {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 6

            Button {
                id: lockButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "lock"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    lockProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Lock Screen"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: logoutButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "logout"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    logoutProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Logout"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: shutdownButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "power_settings_new"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    shutdownProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Shutdown"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }

            Button {
                id: rebootButton
                width: 50
                height: 34
                background: Rectangle {
                    color: parent.hovered ? Theme.primaryLightColor : "transparent"
                    radius: 6
                    opacity: parent.hovered ? 0.8 : 1.0
                }
                contentItem: Text {
                    text: "restart_alt"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.iconSize
                    color: Theme.secondaryColor
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                onClicked: {
                    rebootProcess.running = true
                    root.hidePopup()
                }
                ToolTip.text: "Reboot"
                ToolTip.visible: hovered
                ToolTip.delay: 0
            }
        }

        Button {
            id: newsToggleButton
            anchors.horizontalCenter: parent.horizontalCenter
            width: 215
            height: 30
            background: Rectangle {
                color: parent.hovered ? Theme.primaryLightColor : "transparent"
                radius: 6
                opacity: parent.hovered ? 0.8 : 1.0
            }
            contentItem: Row {
                anchors.centerIn: parent
                spacing: 4
                Text {
                    text: "rss_feed"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.mediumFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: "Arch News"
                    font.family: Theme.primaryFont
                    font.pointSize: Theme.normalFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
                Text {
                    text: newsExpanded ? "unfold_less" : "unfold_more"
                    font.family: Theme.iconFont
                    font.pointSize: Theme.mediumFontSize
                    color: Theme.secondaryColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }
            onClicked: {
                newsExpanded = !newsExpanded
                if (newsExpanded) {
                    fetchArchNews()
                }
            }
            ToolTip.text: newsExpanded ? "Hide Arch News" : "Show Arch News"
            ToolTip.visible: hovered
            ToolTip.delay: 0
        }

        MouseArea {
            id: newsHeaderRow
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: newsExpanded && !errorMessage ? 24 : 0
            visible: newsExpanded && !errorMessage
            hoverEnabled: true
            cursorShape: Qt.PointingHandCursor
            onClicked: fetchArchNews(true)

            Behavior on height {
                NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
            }

            Rectangle {
                anchors.fill: parent
                radius: 4
                color: newsHeaderRow.containsMouse ? Theme.primaryLightColor : "transparent"

                Row {
                    anchors.fill: parent
                    anchors.margins: 4
                    spacing: 6

                    Text {
                        text: "Updated: " + lastFetchTime
                        font.family: Theme.primaryFont
                        font.pointSize: Theme.normalFontSize * 0.8
                        color: Theme.secondaryColor
                        opacity: 0.7
                        anchors.verticalCenter: parent.verticalCenter
                    }

                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        text: "refresh"
                        font.family: Theme.iconFont
                        font.pointSize: Theme.iconSize * 0.5
                        color: Theme.secondaryColor
                        opacity: 0.7
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }

        Text {
            id: errorMessageText
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            visible: newsExpanded && errorMessage !== ""
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            font.family: Theme.primaryFont
            font.pointSize: Theme.normalFontSize * 0.65
            color: "#ff6b6b"
            text: errorMessage
        }

        ScrollView {
            id: newsScrollView
            width: parent.width
            height: newsExpanded ? 200 : 0
            anchors.horizontalCenter: parent.horizontalCenter
            visible: newsExpanded

            Behavior on height {
                NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
            }

            Column {
                width: newsScrollView.width
                spacing: 4

                Repeater {
                    model: newsItems
                    delegate: Rectangle {
                        width: parent.width
                        height: newsItemColumn.height + 8
                        color: newsItemMouseArea.containsMouse ? Theme.primaryLightColor : "transparent"
                        radius: 4

                        MouseArea {
                            id: newsItemMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            onClicked: openUrl(modelData.url)
                        }

                        Column {
                            id: newsItemColumn
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.top: parent.top
                            anchors.margins: 4
                            spacing: 2

                            Text {
                                text: modelData.title
                                font.family: Theme.primaryFont
                                font.pointSize: Theme.normalFontSize * 0.85
                                font.weight: Font.Medium
                                color: Theme.secondaryColor
                                width: parent.width
                                wrapMode: Text.WordWrap
                            }

                            Text {
                                text: formatNewsDate(modelData.date)
                                font.family: Theme.primaryFont
                                font.pointSize: Theme.normalFontSize * 0.8
                                color: Theme.secondaryColor
                                opacity: 0.7
                            }
                        }
                    }
                }
            }
        }
    }
}
