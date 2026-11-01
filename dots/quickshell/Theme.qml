pragma Singleton

import QtQuick
import Quickshell

Singleton {
    id: root

    property string corp: "arasaka"

    readonly property var corps: ({
        arasaka: {
            tag: "荒坂社",
            primary: "#ff4f47",
            secondary: "#45c2cd",
            accent: "#ffd43f",
            bg: "#281419",
            dim: "#796062",
        }
    })

    readonly property var c: corps[corp] ?? corps.arasaka

    readonly property string tag: c.tag
    readonly property color primary: c.primary
    readonly property color secondary: c.secondary
    readonly property color accent: c.accent
    readonly property color bg: c.bg
    readonly property color dim: c.dim
    readonly property color panel: Qt.rgba(bg.r, bg.g, bg.b, 0.72)

    readonly property string font: "Rajdhani Mono"
    readonly property int barHeight: 36
    readonly property int fontSize: 16
}
