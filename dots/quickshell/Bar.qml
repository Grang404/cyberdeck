import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

Scope {
    Variants {
        model: Quickshell.screens

        PanelWindow {
            id: bar

            required property var modelData

            screen: modelData
            anchors {
                top: true
                left: true
                right: true
            }

            implicitHeight: Theme.barHeight
            color: "transparent"
            WlrLayershell.namespace: "cyberdeck-bar"
            exclusionMode: ExclusionMode.Normal
            exclusiveZone: implicitHeight

            Rectangle {
                id: panel
                anchors.fill: parent
                color: Theme.panel

                Scanlines {
                    anchors.fill: parent
                    strength: 0.2
                }

                Rectangle {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    height: 2
                    color: Theme.primary
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.bottomMargin: 2
                    anchors.rightMargin: 16
                    spacing: 16

                    CorpTag {
                        Layout.fillHeight: true
                    }

                    DataStream {
                        Layout.alignment: Qt.AlignVCenter
                        orientation: "vertical"
                    }

                    Workspaces {
                        Layout.alignment: Qt.AlignVCenter
                        screenName: bar.modelData.name
                    }



                    Item { Layout.fillWidth: true }

                    DataStream {
                        Layout.alignment: Qt.AlignVCenter
                        mode: "hex"
                        length: 10
                        group: 2
                    }

                    Visualiser {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Separator {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Network {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Separator {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Stats {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Separator {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Volume {
                        Layout.alignment: Qt.AlignVCenter
                    }
                                        Separator {
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Clock {
                        Layout.alignment: Qt.AlignVCenter
                    }
                }
            }
        }
    }
}
