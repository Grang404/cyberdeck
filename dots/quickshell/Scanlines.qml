import QtQuick

Canvas {
    id: root

    property real strength: 0.18
    property int spacing: 3

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        const ctx = getContext("2d")
        ctx.clearRect(0, 0, width, height)
        ctx.fillStyle = "rgba(0, 0, 0, " + strength + ")"
        for (let y = 0; y < height; y += spacing)
            ctx.fillRect(0, y, width, 1)
    }
}
