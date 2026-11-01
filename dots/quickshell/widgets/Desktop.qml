import qs
import QtQuick
import Quickshell

Scope {
    Variants {
        model: Quickshell.screens

        Scope {
            id: screenScope

            required property var modelData

            DesktopWidget {
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
