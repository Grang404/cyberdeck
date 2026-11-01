import qs
import QtQuick
import QtQuick.Shapes

Item {
    id: root

    property string title: ""
    property string code: ""
    property int cut: 12
    property int pad: 14
    property color accent: Theme.secondary

    default property alias content: body.data

    implicitWidth: Math.max(body.childrenRect.width, header.implicitWidth + codeLabel.implicitWidth + 24) + pad * 2
    implicitHeight: body.y + body.childrenRect.height + pad

    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(Theme.bg.r, Theme.bg.g, Theme.bg.b, 0.6)
        border.width: 1
        border.color: Qt.darker(Theme.primary, 1.3)
    }


    Row {
        id: header
        x: root.pad
        y: root.pad - 4
        height: 18
        spacing: 8

        Rectangle {
            anchors.verticalCenter: parent.verticalCenter
            width: 4
            height: 12
            color: Theme.primary
        }

        GlowText {
            anchors.verticalCenter: parent.verticalCenter
            text: root.title
            pixelSize: 13
            color: Theme.secondary
            ghostColor: Theme.primary
            glow: 0.4
        }
    }

    GlowText {
        id: codeLabel
        x: root.width - root.pad - implicitWidth
        anchors.verticalCenter: header.verticalCenter
        text: root.code
        pixelSize: 11
        color: Theme.dim
        glow: 0
        split: 0
        glitch: false
    }

    Rectangle {
        x: root.pad
        y: header.y + header.height + 3
        width: root.width - root.pad * 2
        height: 1
        color: Qt.darker(Theme.primary, 1.6)
    }

    Item {
        id: body
        x: root.pad
        y: header.y + header.height + 10
        width: childrenRect.width
        height: childrenRect.height
    }
}
