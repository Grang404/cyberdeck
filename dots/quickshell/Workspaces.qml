pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Hyprland

Row {
    id: root

    property string screenName: ""

    readonly property bool multi: Quickshell.screens.length > 1

    readonly property var layouts: ({
        "DP-1": { persistent: [1, 2, 3, 4, 5], overflow: [11, 12, 13, 14] },
        "DP-2": { persistent: [6, 7, 8, 9, 10], overflow: [16, 17, 18, 19] }
    })

    readonly property var single: ({ persistent: [1, 2, 3, 4, 5], overflow: [6, 7, 8, 9] })

    readonly property var layout: multi ? (layouts[screenName] ?? null) : single

    readonly property var entries: {
        if (layout) {
            const n = layout.persistent.length
            const p = layout.persistent.map((id, i) => ({ name: String(id), label: String(i + 1), persistent: true }))
            const o = layout.overflow.map((id, i) => ({ name: String(id), label: String(n + i + 1), persistent: false }))
            return p.concat(o)
        }
        return Hyprland.workspaces.values
            .filter(w => w.monitor?.name === screenName)
            .map(w => ({ name: w.name, label: w.name.toUpperCase(), persistent: false }))
    }

    spacing: 4

    Repeater {
        model: root.entries

        delegate: Item {
            id: cell

            required property var modelData
            readonly property string wsName: modelData.name
            readonly property var ws: Hyprland.workspaces.values.find(w => w.name === wsName) ?? null
            readonly property bool occupied: ws !== null
            readonly property bool active: ws?.active ?? false
            property int cut: 6
            property real r: 2

            visible: modelData.persistent || occupied
            width: Math.max(28, label.implicitWidth + 12)
            height: 20
            anchors.verticalCenter: parent.verticalCenter

            Shape {
                anchors.fill: parent
                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeWidth: 1
                    strokeColor: cell.active || cell.occupied ? Theme.secondary : Theme.dim
                    fillColor: cell.active ? Theme.secondary : "transparent"
                    startX: 0.5 + cell.r
                    startY: 0.5
                    PathLine { x: cell.width - 0.5 - cell.r; y: 0.5 }
                    PathQuad { x: cell.width - 0.5; y: 0.5 + cell.r; controlX: cell.width - 0.5; controlY: 0.5 }
                    PathLine { x: cell.width - 0.5; y: cell.height - 0.5 - cell.cut }
                    PathLine { x: cell.width - 0.5 - cell.cut; y: cell.height - 0.5 }
                    PathLine { x: 0.5 + cell.r; y: cell.height - 0.5 }
                    PathQuad { x: 0.5; y: cell.height - 0.5 - cell.r; controlX: 0.5; controlY: cell.height - 0.5 }
                    PathLine { x: 0.5; y: 0.5 + cell.r }
                    PathQuad { x: 0.5 + cell.r; y: 0.5; controlX: 0.5; controlY: 0.5 }
                }
            }

            GlowText {
                id: label
                anchors.centerIn: parent
                text: cell.modelData.label.padStart(2, "0")
                pixelSize: 13
                color: cell.active ? Theme.bg : (cell.occupied ? Theme.secondary : Theme.dim)
                ghostColor: cell.active ? Theme.bg : Theme.primary
                glow: cell.active ? 0 : (cell.occupied ? 0.5 : 0)
                split: cell.active || !cell.occupied ? 0 : 1
                glitch: cell.occupied && !cell.active
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    const numeric = /^\d+$/.test(cell.wsName)
                    if (Hyprland.usingLua) {
                        const target = numeric ? cell.wsName : '"name:' + cell.wsName + '"'
                        Hyprland.dispatch("hl.dsp.focus({ workspace = " + target + " })")
                    } else {
                        Hyprland.dispatch("workspace " + (numeric ? cell.wsName : "name:" + cell.wsName))
                    }
                }
            }
        }
    }
}
