import QtQuick
import Quickshell
import Quickshell.Io
import qs

Scope {
    id: root

    property bool enabled: true
    property var hidden: ({})

    function isShown(name) {
        return enabled && !hidden[name]
    }

    IpcHandler {
        target: "widgets"

        function toggle(): void {
            root.enabled = !root.enabled
        }

        function show(): void {
            root.enabled = true
        }

        function hide(): void {
            root.enabled = false
        }

        function toggleOne(name: string): void {
            const h = Object.assign({}, root.hidden)
            h[name] = !h[name]
            root.hidden = h
        }

        function status(): string {
            return (root.enabled ? "on" : "off") + " | hidden: " + (Object.keys(root.hidden).filter(k => root.hidden[k]).join(", ") || "none")
        }
    }

    Variants {
        model: Quickshell.screens

        Scope {
            id: screenScope

            required property var modelData

            DesktopWidget {
                visible: root.isShown("sysdiag")
                screen: screenScope.modelData
                anchors {
                    top: true
                    left: true
                }
                margins.top: 24
                margins.left: 24

                SysDiag {}
            }

            DesktopWidget {
                visible: root.isShown("breach")
                screen: screenScope.modelData
                anchors {
                    top: true
                    right: true
                }
                margins.top: 24
                margins.right: 24

                BreachMatrix {}
            }

            DesktopWidget {
                visible: root.isShown("log")
                screen: screenScope.modelData
                anchors {
                    bottom: true
                    left: true
                }
                margins.bottom: 24
                margins.left: 24

                DaemonLog {}
            }
        }
    }
}
