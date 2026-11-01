import Quickshell
import Quickshell.Io

ShellRoot {
    Bar {}

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
