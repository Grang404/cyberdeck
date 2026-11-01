import Quickshell
import Quickshell.Io
import qs.widgets

ShellRoot {
    Bar {}
    Desktop {}

    IpcHandler {
        target: "theme"

        function set(corp: string): void {
            Theme.corp = corp
        }

        function get(): string {
            return Theme.corp
        }
    }
}
