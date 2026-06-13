// Shared custom app-icon cache
// Scans ~/Pictures/assets/icons/apps for *.png/*.svg/*.ico once and exposes a
// name -> file-url lookup. Used by Workspace (opened-apps) and the SystemTray
// fallbacks so "drop a file in apps/" is the single way to brand an app/daemon
// that has no standard desktop icon (e.g. genshin-impact.ico, hoyoplay.png).

pragma Singleton
pragma ComponentBehavior: Bound
import QtQuick
import Quickshell
import Qt.labs.folderlistmodel

Singleton {
    id: root

    readonly property string iconDir: Quickshell.env("HOME") + "/Pictures/assets/icons/apps"

    // baseName variants -> "file://.../<file>" (mutated in place; see `ready`)
    property var cache: ({})

    // Flipped true once the scan finishes. Consumers must reference this in their
    // icon bindings so they re-evaluate when the scan completes — the `cache`
    // object is mutated in place and does not itself trigger bindings.
    property bool ready: false

    // Normalize a lookup key the same way filenames are keyed (lowercase, spaces
    // collapsed to hyphens) so "Genshin Impact" matches "genshin-impact.ico".
    function normalize(key) {
        return key.toLowerCase().replace(/ /g, "-")
    }

    // Resolve an app/daemon name to a custom icon file url, or "" on miss.
    // Order: exact -> normalized -> partial/substring (mirrors the old Workspace
    // matcher so nothing regresses).
    function lookup(key) {
        if (!ready || !key || key.length === 0)
            return ""

        if (cache[key])
            return cache[key]

        const norm = normalize(key)
        if (cache[norm])
            return cache[norm]

        for (const cachedName in cache) {
            if (cachedName.includes(norm) || norm.includes(cachedName))
                return cache[cachedName]
        }
        return ""
    }

    FolderListModel {
        id: iconFolder
        folder: "file://" + root.iconDir
        nameFilters: ["*.png", "*.svg", "*.ico"]
        showDirs: false

        function rebuild() {
            const next = {}
            for (let i = 0; i < count; i++) {
                const fileName = get(i, "fileName")
                const baseName = fileName.replace(/\.(png|svg|ico)$/i, "")
                const fullPath = "file://" + root.iconDir + "/" + fileName

                next[baseName] = fullPath
                next[baseName.toLowerCase()] = fullPath
                next[baseName.replace(/-/g, " ")] = fullPath
            }
            root.cache = next
            root.ready = true
            console.log("AppIconCache: icons pre-cached:", Object.keys(next).length)
        }

        onCountChanged: rebuild()
        onStatusChanged: {
            if (status === FolderListModel.Ready)
                rebuild()
            else if (status === FolderListModel.Error)
                root.ready = true // unblock consumers even if the dir is missing
        }
    }
}
