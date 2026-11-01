import QtQuick

Item {
    id: root

    property string mode: "bin"
    property string orientation: "horizontal"
    property int length: 12
    property int group: 0
    property int rows: 3
    property int columns: 2
    property real rowSpacing: -2
    property real columnSpacing: 2
    property int interval: 120
    property color color: Theme.dim
    property color ghostColor: Theme.primary
    property real pixelSize: orientation === "vertical" ? 8 : 11
    property real glow: 0.3
    property bool glitch: true

    property string buffer: ""
    property var cols: []

    readonly property bool horizontal: orientation !== "vertical"
    readonly property string charset: mode === "hex" ? "0123456789ABCDEF" : "01"
    readonly property string display: group > 0
        ? (buffer.match(new RegExp(".{1," + group + "}", "g")) ?? []).join(" ")
        : buffer

    implicitWidth: horizontal ? hLabel.implicitWidth : vGrid.implicitWidth
    implicitHeight: horizontal ? hLabel.implicitHeight : vGrid.implicitHeight

    function rand() {
        return charset[Math.floor(Math.random() * charset.length)]
    }

    function randString(n) {
        let s = ""
        for (let i = 0; i < n; i++)
            s += rand()
        return s
    }

    function fill() {
        buffer = randString(length)
        const c = []
        for (let i = 0; i < columns; i++)
            c.push(randString(rows))
        cols = c
    }

    function tick() {
        if (horizontal) {
            buffer = buffer.slice(1) + rand()
            return
        }
        cols = cols.map((s, i) => i % 2 === 0 ? rand() + s.slice(0, -1) : s.slice(1) + rand())
    }

    Component.onCompleted: fill()
    onModeChanged: fill()
    onLengthChanged: fill()
    onRowsChanged: fill()
    onColumnsChanged: fill()

    Timer {
        interval: root.interval
        running: true
        repeat: true
        onTriggered: root.tick()
    }

    GlowText {
        id: hLabel
        visible: root.horizontal
        text: root.display
        pixelSize: root.pixelSize
        color: root.color
        ghostColor: root.ghostColor
        glow: root.glow
        split: 0.5
        glitch: root.glitch
    }

    Row {
        id: vGrid
        visible: !root.horizontal
        spacing: root.columnSpacing

        Repeater {
            model: root.horizontal ? 0 : root.columns

            delegate: Column {
                id: col

                required property int index

                spacing: root.rowSpacing

                Repeater {
                    model: root.rows

                    delegate: GlowText {
                        required property int index

                        text: (root.cols[col.index] ?? "")[index] ?? ""
                        pixelSize: root.pixelSize
                        color: root.color
                        ghostColor: root.ghostColor
                        glow: root.glow
                        split: 0.5
                        glitch: root.glitch
                    }
                }
            }
        }
    }
}
