import QtQuick
import Quickshell

Item {
    id: root

    property bool loreYear: true
    property bool showDate: false

    implicitWidth: label.implicitWidth
    implicitHeight: label.implicitHeight

    SystemClock {
        id: clock
        precision: SystemClock.Seconds
    }

    GlowText {
        id: label
        anchors.centerIn: parent
        text: root.showDate
            ? (Qt.formatDateTime(clock.date, "dd.MM.") + (root.loreYear ? "2077" : Qt.formatDateTime(clock.date, "yyyy"))).toUpperCase()
            : Qt.formatDateTime(clock.date, "hh:mm")
        pixelSize: 19
        color: Theme.secondary
        ghostColor: Theme.primary
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: root.showDate = !root.showDate
    }
}
