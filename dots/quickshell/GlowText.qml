pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects

Item {
    id: root

    property string text: ""
    property color color: Theme.primary
    property color ghostColor: Theme.secondary
    property real pixelSize: Theme.fontSize
    property bool bold: true
    property real glow: 0.7
    property real split: 1.0
    property bool glitch: true
    property real jitter: 0

    implicitWidth: main.implicitWidth
    implicitHeight: main.implicitHeight

    Text {
        x: -root.split - root.jitter
        text: root.text
        font: main.font
        color: root.ghostColor
        opacity: 0.5
        topPadding: 1
    }

    Text {
        x: root.split + root.jitter
        text: root.text
        font: main.font
        color: Qt.darker(root.color, 1.6)
        opacity: 0.6
        topPadding: 2
    }

    Text {
        id: main
        text: root.text
        color: root.color
        font.family: Theme.font
        font.pixelSize: root.pixelSize
        font.bold: root.bold
        topPadding: 2
    }

    layer.enabled: root.glow > 0
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: root.color
        shadowBlur: root.glow
        shadowHorizontalOffset: 0
        shadowVerticalOffset: 0
        blurMax: 24
    }

    Timer {
        running: root.glitch
        repeat: true
        interval: 250
        onTriggered: if (Math.random() < 0.04) burst.restart()
    }

    SequentialAnimation {
        id: burst
        ScriptAction { script: root.jitter = 2 + Math.random() * 3 }
        PauseAnimation { duration: 60 }
        ScriptAction { script: root.jitter = -1 - Math.random() * 2 }
        PauseAnimation { duration: 40 }
        ScriptAction { script: root.jitter = 0 }
    }
}
