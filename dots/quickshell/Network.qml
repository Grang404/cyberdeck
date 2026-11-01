import QtQuick
import QtQuick.Effects
import Quickshell.Io

Row {
    id: root

    property int bars: 4
    property int interval: 2000
    property int historyLength: 30
    property int graphWidth: 60
    property int graphHeight: 20
    property real floor: 10240

    property var rxHistory: []
    property var txHistory: []

    property string iface: ""
    property bool wireless: false
    property real quality: 0
    property int linkSpeed: -1
    property real rxRate: 0
    property real txRate: 0
    property real lastRx: -1
    property real lastTx: -1
    property real lastTime: 0

    readonly property bool online: iface !== ""
    readonly property real strength: !online ? 0 : (wireless ? quality : 1)
    readonly property bool wired: online && !wireless

    spacing: 6

    function parseRoute(s) {
        let best = null
        for (const l of s.trim().split("\n").slice(1)) {
            const f = l.trim().split(/\s+/)
            if (f[1] === "00000000" && f[7] === "00000000") {
                const metric = Number(f[6])
                if (best === null || metric < best.metric)
                    best = { name: f[0], metric: metric }
            }
        }
        const name = best ? best.name : ""
        if (name !== iface) {
            iface = name
            lastRx = -1
            lastTx = -1
            rxRate = 0
            txRate = 0
            rxHistory = []
            txHistory = []
            graph.requestPaint()
        }
    }

    function findLine(s) {
        return s.split("\n").find(l => l.trim().startsWith(iface + ":"))
    }

    function parseDev(s) {
        const line = findLine(s)
        if (!line)
            return
        const f = line.split(":")[1].trim().split(/\s+/).map(Number)
        const rx = f[0]
        const tx = f[8]
        const now = Date.now()
        if (lastRx >= 0 && now > lastTime) {
            const dt = (now - lastTime) / 1000
            rxRate = Math.max(0, (rx - lastRx) / dt)
            txRate = Math.max(0, (tx - lastTx) / dt)
            push(rxHistory, rxRate)
            push(txHistory, txRate)
            graph.requestPaint()
        }
        lastRx = rx
        lastTx = tx
        lastTime = now
    }

    function parseWireless(s) {
        const line = findLine(s)
        wireless = line !== undefined
        if (wireless)
            quality = Math.min(1, Number(line.split(":")[1].trim().split(/\s+/)[1]) / 70)
        else
            speed.reload()
    }

    function fmtSpeed(mbit) {
        if (mbit <= 0)
            return ""
        return mbit >= 1000 ? (mbit / 1000) + "G" : mbit + "M"
    }

    function push(arr, v) {
        arr.push(v)
        while (arr.length > historyLength)
            arr.shift()
    }

    FileView {
        id: route
        path: "/proc/net/route"
        onLoaded: {
            root.parseRoute(route.text())
            if (root.online) {
                dev.reload()
                wifi.reload()
            }
        }
    }

    FileView {
        id: dev
        path: "/proc/net/dev"
        onLoaded: root.parseDev(dev.text())
    }

    FileView {
        id: wifi
        path: "/proc/net/wireless"
        onLoaded: root.parseWireless(wifi.text())
    }

    FileView {
        id: speed
        path: root.iface ? "/sys/class/net/" + root.iface + "/speed" : ""
        printErrors: false
        onLoaded: root.linkSpeed = Number(speed.text().trim())
        onLoadFailed: root.linkSpeed = -1
    }

    Timer {
        interval: root.interval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: route.reload()
    }

    GlowText {
        anchors.verticalCenter: parent.verticalCenter
        text: "NET"
        pixelSize: 13
        color: Theme.secondary
        ghostColor: Theme.primary
        glow: 0.4
        glitch: false
    }

    Row {
        visible: !root.wired
        anchors.verticalCenter: parent.verticalCenter
        height: 4 + (root.bars - 1) * 2
        spacing: 2

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Theme.primary
            shadowBlur: 0.5
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            blurMax: 16
        }

        Repeater {
            model: root.bars

            delegate: Rectangle {
                required property int index
                readonly property bool lit: root.strength * root.bars >= index + 0.5

                anchors.bottom: parent.bottom
                width: 3
                height: 4 + index * 2
                color: lit ? Theme.primary : "transparent"
                border.width: 1
                border.color: lit ? Theme.primary : Qt.darker(Theme.primary, 1.8)
            }
        }
    }

    Rectangle {
        visible: root.wired
        anchors.verticalCenter: parent.verticalCenter
        width: hardline.implicitWidth + 10
        height: hardline.implicitHeight + 2
        color: "transparent"
        border.width: 1
        border.color: Theme.primary

        GlowText {
            id: hardline
            anchors.centerIn: parent
            text: "LINK" + (root.fmtSpeed(root.linkSpeed) ? " " + root.fmtSpeed(root.linkSpeed) : "")
            pixelSize: 11
            color: Theme.primary
            glow: 0.5
            glitch: false
        }
    }

    GlowText {
        visible: !root.online
        anchors.verticalCenter: parent.verticalCenter
        text: "OFFLINE"
        pixelSize: 13
        color: Theme.primary
        glow: 0.5
        glitch: true
    }

    Canvas {
        id: graph

        readonly property color rxColor: Theme.primary
        readonly property color txColor: Theme.secondary
        readonly property color frameColor: Qt.darker(Theme.primary, 1.8)

        visible: root.online
        anchors.verticalCenter: parent.verticalCenter
        width: root.graphWidth
        height: root.graphHeight

        onRxColorChanged: requestPaint()
        onTxColorChanged: requestPaint()

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

            const rx = root.rxHistory
            const tx = root.txHistory
            if (rx.length < 2)
                return

            const max = Math.max(root.floor, ...rx, ...tx)
            const step = (width - 2) / (root.historyLength - 1)
            const px = (i, len) => width - 1 - (len - 1 - i) * step
            const py = v => height - 1.5 - (v / max) * (height - 3)

            ctx.beginPath()
            ctx.moveTo(px(0, rx.length), height - 1)
            for (let i = 0; i < rx.length; i++)
                ctx.lineTo(px(i, rx.length), py(rx[i]))
            ctx.lineTo(px(rx.length - 1, rx.length), height - 1)
            ctx.closePath()
            ctx.fillStyle = Qt.rgba(rxColor.r, rxColor.g, rxColor.b, 0.35)
            ctx.fill()

            ctx.beginPath()
            for (let i = 0; i < rx.length; i++)
                i === 0 ? ctx.moveTo(px(i, rx.length), py(rx[i])) : ctx.lineTo(px(i, rx.length), py(rx[i]))
            ctx.strokeStyle = rxColor
            ctx.stroke()

            ctx.beginPath()
            for (let i = 0; i < tx.length; i++)
                i === 0 ? ctx.moveTo(px(i, tx.length), py(tx[i])) : ctx.lineTo(px(i, tx.length), py(tx[i]))
            ctx.strokeStyle = txColor
            ctx.stroke()
        }
    }
}
