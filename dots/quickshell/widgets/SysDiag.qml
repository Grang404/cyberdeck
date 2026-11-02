import qs
import QtQuick
import Quickshell.Io

WidgetFrame {
    id: root

    property string host: ""
    property string kernel: ""
    property real uptime: 0
    property string load: ""

    readonly property var rows: [
        ["HOST", host.toUpperCase()],
        ["KERNEL", kernel],
        ["UPTIME", fmtUptime(uptime)],
        ["LOAD", load]
    ]

    title: "SYS.DIAG"
    code: "0x01"

    function pad2(n) {
        return String(n).padStart(2, "0")
    }

    function fmtUptime(s) {
        const d = Math.floor(s / 86400)
        const h = Math.floor(s % 86400 / 3600)
        const m = Math.floor(s % 3600 / 60)
        return (d > 0 ? pad2(d) + "D " : "") + pad2(h) + "H " + pad2(m) + "M"
    }

    FileView {
        id: hostFile
        path: "/proc/sys/kernel/hostname"
        onLoaded: root.host = hostFile.text().trim()
    }

    FileView {
        id: kernelFile
        path: "/proc/sys/kernel/osrelease"
        onLoaded: root.kernel = kernelFile.text().trim()
    }

    FileView {
        id: uptimeFile
        path: "/proc/uptime"
        onLoaded: root.uptime = Number(uptimeFile.text().split(" ")[0])
    }

    FileView {
        id: loadFile
        path: "/proc/loadavg"
        onLoaded: root.load = loadFile.text().split(" ").slice(0, 3).join(" ")
    }

    Timer {
        interval: 5000
        running: true
        repeat: true
        onTriggered: {
            uptimeFile.reload()
            loadFile.reload()
        }
    }

    Column {
        spacing: 3

        Repeater {
            model: root.rows.length

            delegate: Row {
                required property int index

                GlowText {
                    width: 72
                    text: root.rows[index][0]
                    pixelSize: 12
                    color: Theme.secondary
                    ghostColor: Theme.primary
                    glow: 0.3
                    split: 0.5
                    glitch: false
                }

                GlowText {
                    text: root.rows[index][1]
                    pixelSize: 12
                    color: Theme.primary
                    glow: 0.3
                    glitch: false
                }
            }
        }

        Item {
            width: 1
            height: 6
        }

        Stats {}
    }
}
