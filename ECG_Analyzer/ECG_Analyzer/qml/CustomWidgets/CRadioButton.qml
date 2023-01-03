import QtQuick 2.12
import QtQuick.Controls 2.12

RadioButton {
    id: control

    indicator: Rectangle {
        implicitWidth: 26
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? buttonColor1 : fontColor

        Text {
            anchors.fill: parent
            text: control.text
            font: control.font
            opacity: enabled ? 1.0 : 0.3
            color: backgroundColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }
    }

    contentItem: Text {
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: "transparent"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
