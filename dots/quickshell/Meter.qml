import QtQuick
import QtQuick.Effects

Row {
    id: root

    property string label: ""
    property real value: 0
    property int digits: 2
    property int segments: 5
    property color hotColor: Theme.accent

    readonly property bool hot: value >= 0.85
    readonly property color tint: hot ? hotColor : Theme.primary

    spacing: 6

    GlowText {
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        pixelSize: 13
        color: Theme.secondary
        ghostColor: Theme.primary
        glow: 0.4
        glitch: false
    }

    Row {
        anchors.verticalCenter: parent.verticalCenter
        spacing: 2

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: root.tint
            shadowBlur: 0.5
            shadowHorizontalOffset: 0
            shadowVerticalOffset: 0
            blurMax: 16
        }

        Repeater {
            model: root.segments

            delegate: Rectangle {
                id: seg

                required property int index
                readonly property real fill: Math.max(0, Math.min(1, root.value * root.segments - index))

                width: 6
                height: 10
                color: "transparent"
                border.width: 1
                border.color: Qt.darker(root.tint, 1.8)

                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * seg.fill
                    color: root.tint
                }
            }
        }
    }

    GlowText {
        anchors.verticalCenter: parent.verticalCenter
        text: String(Math.round(root.value * 100)).padStart(root.digits, "0") + "%"
        pixelSize: 13
        color: root.tint
        glow: 0.3
        glitch: false
    }
}
