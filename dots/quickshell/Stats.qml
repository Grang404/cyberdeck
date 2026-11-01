import QtQuick
import Quickshell.Io

Row {
    id: root

    property real cpu: 0
    property real mem: 0
    property real lastIdle: 0
    property real lastTotal: 0

    spacing: 16

    function parseStat(s) {
        const f = s.split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
        const idle = f[3] + f[4]
        const total = f.reduce((a, b) => a + b, 0)
        if (lastTotal > 0 && total > lastTotal)
            cpu = 1 - (idle - lastIdle) / (total - lastTotal)
        lastIdle = idle
        lastTotal = total
    }

    function parseMem(s) {
        const total = Number(s.match(/MemTotal:\s+(\d+)/)?.[1] ?? 0)
        const avail = Number(s.match(/MemAvailable:\s+(\d+)/)?.[1] ?? 0)
        if (total > 0)
            mem = 1 - avail / total
    }

    FileView {
        id: stat
        path: "/proc/stat"
        onLoaded: root.parseStat(stat.text())
    }

    FileView {
        id: meminfo
        path: "/proc/meminfo"
        onLoaded: root.parseMem(meminfo.text())
    }

    Timer {
        interval: 2000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            stat.reload()
            meminfo.reload()
        }
    }

    Meter {
        anchors.verticalCenter: parent.verticalCenter
        label: "CPU"
        value: root.cpu
    }

    Meter {
        anchors.verticalCenter: parent.verticalCenter
        label: "RAM"
        value: root.mem
    }
}
