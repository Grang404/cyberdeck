import QtQuick

Rectangle {
    id: root

    implicitWidth: label.implicitWidth + 24
    color: Theme.primary

    Text {
        id: label
        anchors.centerIn: parent
        text: Theme.tag + " // "
        color: Theme.bg
        font.family: Theme.font
        font.pixelSize: Theme.fontSize
        font.bold: true
    }

    Rectangle {
        anchors.left: parent.right
        anchors.leftMargin: 3
        width: 4
        height: parent.height
        color: Theme.primary
    }
}
