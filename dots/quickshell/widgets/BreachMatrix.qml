import QtQuick
import qs

WidgetFrame {
    id: root

    property int size: 5
    property int bufferSize: 6
    property int stepInterval: 700
    property int holdTime: 2500
    property int streamInterval: 400
    readonly property var codes: ["1C", "55", "7A", "BD", "E9", "FF"]

    property var grid: []
    property var used: []
    property var buffer: []
    property int cursor: -1
    property bool rowMode: true
    property int line: 0
    property bool success: false
    property bool streaming: false

    title: "BREACH PROTOCOL"
    code: "ICE//7A"

    function randomGrid() {
        const g = []
        for (let i = 0; i < size * size; i++)
            g.push(codes[Math.floor(Math.random() * codes.length)])
        return g
    }

    function hexByte() {
        return Math.floor(Math.random() * 256).toString(16).toUpperCase().padStart(2, "0")
    }

    function reset() {
        grid = randomGrid()
        used = []
        buffer = []
        cursor = -1
        rowMode = true
        line = 0
        success = false
        streaming = false
    }

    function streamStep() {
        const row = []
        for (let i = 0; i < size; i++)
            row.push(hexByte())
        grid = row.concat(grid.slice(0, size * (size - 1)))
    }

    function step() {
        if (streaming) {
            streamStep()
            return
        }
        if (success) {
            streaming = true
            return
        }
        const cand = []
        for (let k = 0; k < size; k++) {
            const idx = rowMode ? line * size + k : k * size + line
            if (!used.includes(idx))
                cand.push(idx)
        }
        if (cand.length === 0) {
            reset()
            return
        }
        const pick = cand[Math.floor(Math.random() * cand.length)]
        cursor = pick
        used = used.concat([pick])
        buffer = buffer.concat([grid[pick]])
        line = rowMode ? pick % size : Math.floor(pick / size)
        rowMode = !rowMode
        if (buffer.length >= bufferSize)
            success = true
    }

    Component.onCompleted: reset()

    Timer {
        interval: root.streaming ? root.streamInterval : (root.success ? root.holdTime : root.stepInterval)
        running: true
        repeat: true
        onTriggered: root.step()
    }

    Column {
        spacing: 10

        Grid {
            columns: root.size
            spacing: 4

            Repeater {
                model: root.size * root.size

                delegate: Rectangle {
                    id: cell

                    required property int index
                    readonly property int row: Math.floor(index / root.size)
                    readonly property bool isCursor: !root.streaming && index === root.cursor
                    readonly property bool isUsed: !root.streaming && root.used.includes(index)
                    readonly property bool inLine: !root.streaming && !root.success && (root.rowMode
                        ? row === root.line
                        : index % root.size === root.line)

                    width: 30
                    height: 20
                    opacity: root.streaming ? 1 - row * 0.15 : 1
                    color: isCursor ? Theme.secondary
                        : (inLine ? Qt.rgba(Theme.secondary.r, Theme.secondary.g, Theme.secondary.b, 0.12) : "transparent")

                    GlowText {
                        anchors.centerIn: parent
                        text: cell.isUsed && !cell.isCursor ? "[ ]" : (root.grid[cell.index] ?? "")
                        pixelSize: 12
                        color: cell.isCursor ? Theme.bg
                            : (cell.isUsed ? Theme.dim : (cell.inLine ? Theme.secondary : Theme.primary))
                        glow: cell.isCursor ? 0 : 0.3
                        split: cell.isCursor ? 0 : 0.5
                        glitch: false
                    }
                }
            }
        }

        Row {
            spacing: 5

            GlowText {
                anchors.verticalCenter: parent.verticalCenter
                text: "BUFFER"
                pixelSize: 11
                color: Theme.dim
                glow: 0
                split: 0
                glitch: false
            }

            Repeater {
                model: root.bufferSize

                delegate: Rectangle {
                    id: slot

                    required property int index

                    width: 22
                    height: 16
                    color: "transparent"
                    border.width: 1
                    border.color: index < root.buffer.length ? Theme.secondary : Qt.darker(Theme.primary, 1.8)

                    GlowText {
                        anchors.centerIn: parent
                        text: root.buffer[slot.index] ?? ""
                        pixelSize: 11
                        color: Theme.secondary
                        glow: 0.3
                        split: 0
                        glitch: false
                    }
                }
            }
        }

        Item {
            width: widest.implicitWidth
            height: status.implicitHeight

            GlowText {
                id: widest
                visible: false
                text: "BREACH SUCCESSFUL // DAEMON UPLOADED"
                pixelSize: 11
                glow: 0
                glitch: false
            }

            GlowText {
                id: status
                text: root.streaming ? "LINK ESTABLISHED // STREAMING"
                    : (root.success ? "BREACH SUCCESSFUL // DAEMON UPLOADED" : "UPLOADING DAEMON...")
                pixelSize: 11
                color: root.streaming ? Theme.secondary : (root.success ? Theme.accent : Theme.dim)
                glow: root.success ? 0.5 : 0
                split: root.success && !root.streaming ? 1 : 0
                glitch: root.success && !root.streaming
            }
        }
    }
}
