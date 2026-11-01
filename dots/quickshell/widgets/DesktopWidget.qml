import qs
import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    default property alias content: holder.data

    color: "transparent"
    WlrLayershell.layer: WlrLayer.Bottom
    WlrLayershell.namespace: "cyberdeck-desktop"

    implicitWidth: holder.childrenRect.width
    implicitHeight: holder.childrenRect.height

    Item {
        id: holder
        anchors.fill: parent
    }
}
