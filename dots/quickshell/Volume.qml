import QtQuick
import Quickshell.Services.Pipewire

Item {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property real volume: sink?.audio?.volume ?? 0
    readonly property bool muted: sink?.audio?.muted ?? false

    implicitWidth: meter.implicitWidth
    implicitHeight: meter.implicitHeight

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    Meter {
        id: meter
        hotColor: Theme.secondary
        digits: 3
        label: root.muted ? "MUTE" : "VOL"
        value: root.muted ? 0 : root.volume
        segments: 5
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            if (root.sink?.audio)
                root.sink.audio.muted = !root.sink.audio.muted
        }
        onWheel: wheel => {
            if (!root.sink?.audio)
                return
            const step = wheel.angleDelta.y > 0 ? 0.05 : -0.05
            root.sink.audio.volume = Math.max(0, Math.min(1, root.sink.audio.volume + step))
        }
    }
}
