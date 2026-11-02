import qs
import QtQuick
import Quickshell

WidgetFrame {
    id: root

    property int maxLines: 8
    property int logWidth: 300
    property var lines: []

    readonly property var messages: [
        ["ICE handshake complete", 0],
        ["subnet 0x7A scan complete", 0],
        ["rerouting via node 0xBD", 0],
        ["packet integrity 100%", 0],
        ["firewall sweep // clean", 0],
        ["ghost process terminated", 0],
        ["daemon PING injected", 1],
        ["quickhack queue flushed", 1],
        ["access point 0x1C breached", 1],
        ["datashard decrypted", 1],
        ["relic integrity nominal", 1],
        ["trace attempt blocked", 2],
        ["Black ICE signature detected", 2],
        ["netwatch probe deflected", 2]
    ]

    title: "NET.LOG"
    code: "TRACE//OFF"

    ListModel {
        id: logModel
    }

    function push() {
        const m = messages[Math.floor(Math.random() * messages.length)]
        logModel.append({ t: Qt.formatDateTime(clock.date, "hh:mm:ss"), msg: m[0].toUpperCase(), lvl: m[1] })
        while (logModel.count > maxLines)
            logModel.remove(0)
        tick.interval = 600 + Math.random() * 2200
    }

    Component.onCompleted: {
        for (let i = 0; i < maxLines; i++)
            push()
    }

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    Timer {
        id: tick
        interval: 1000
        running: true
        repeat: true
        onTriggered: root.push()
    }

    Column {
        width: root.logWidth
        spacing: 1

        Repeater {
            model: logModel

            delegate: Row {
                required property string t
                required property string msg
                required property int lvl
                required property int index

                spacing: 8
                opacity: 0.35 + 0.65 * (index + 1) / logModel.count

                GlowText {
                    text: "[" + t + "]"
                    pixelSize: 11
                    color: Theme.dim
                    glow: 0
                    split: 0
                    glitch: false
                }

                GlowText {
                    text: msg
                    pixelSize: 11
                    color: lvl === 2 ? Theme.accent : (lvl === 1 ? Theme.secondary : Theme.primary)
                    glow: 0.3
                    glitch: lvl === 2
                }
            }
        }
    }
}
