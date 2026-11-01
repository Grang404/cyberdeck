import QtQuick
import QtQuick.Effects
import Quickshell.Io

Item {
    id: root

    property int graphWidth: 64
    property int graphHeight: 16
    property real peakFall: 0.02

    property var levels: []
    property var peaks: []
    property double lastFrame: 0

    readonly property string config: Qt.resolvedUrl("cava.conf").toString().replace("file://", "")

    implicitWidth: graphWidth
    implicitHeight: graphHeight

    function frame(line) {
        const v = line.split(";").filter(x => x !== "").map(x => Number(x) / 100)
        if (v.length === 0)
            return
        const p = peaks.length === v.length ? peaks : v.map(() => 0)
        for (let i = 0; i < v.length; i++)
            p[i] = Math.max(v[i], p[i] - peakFall)
        levels = v
        peaks = p
        lastFrame = Date.now()
        canvas.requestPaint()
    }

    Process {
        id: cava
        command: ["cava", "-p", root.config]
        running: true
        stdout: SplitParser {
            onRead: data => root.frame(data)
        }
        onExited: restart.start()
    }

    Timer {
        id: restart
        interval: 2000
        onTriggered: cava.running = true
    }

    Timer {
        interval: 250
        running: true
        repeat: true
        onTriggered: {
            if (Date.now() - root.lastFrame > 500 && root.levels.some(x => x > 0)) {
                root.levels = root.levels.map(() => 0)
                root.peaks = root.peaks.map(() => 0)
                canvas.requestPaint()
            }
        }
    }

    Canvas {
        id: canvas

        readonly property color barColor: Theme.primary
        readonly property color peakColor: Theme.secondary
        readonly property color frameColor: Qt.darker(Theme.primary, 1.8)

        anchors.fill: parent

        onBarColorChanged: requestPaint()
        onPeakColorChanged: requestPaint()

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.primary
            shadowBlur: 0.4
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            blurMax: 16
        }

        onPaint: {
            const ctx = getContext("2d")
            ctx.clearRect(0, 0, width, height)

            ctx.lineWidth = 1
            ctx.strokeStyle = frameColor
            ctx.strokeRect(0.5, 0.5, width - 1, height - 1)

            const v = root.levels
            const n = v.length
            if (n === 0)
                return

            const slot = (width - 2) / n
            const bw = Math.max(1, Math.floor(slot) - 1)
            const ih = height - 3
            const bottom = height - 1

            for (let i = 0; i < n; i++) {
                const x = Math.round(1 + i * slot)
                const h = Math.round(v[i] * ih)
                if (h > 0) {
                    ctx.fillStyle = Qt.rgba(barColor.r, barColor.g, barColor.b, 0.35)
                    ctx.fillRect(x, bottom - h, bw, h)
                    ctx.fillStyle = barColor
                    ctx.fillRect(x, bottom - h, bw, 1)
                }
                const p = root.peaks[i] ?? 0
                if (p > 0.02) {
                    ctx.fillStyle = peakColor
                    ctx.fillRect(x, Math.round(bottom - 1 - p * ih), bw, 1)
                }
            }
        }
    }
}
