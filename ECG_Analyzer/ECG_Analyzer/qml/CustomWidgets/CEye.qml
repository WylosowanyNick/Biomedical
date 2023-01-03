import QtQuick 2.12
import QtQuick.Controls 2.12

RadioButton {
    id: control
    property int num: 0

    indicator: Rectangle {
        color: "transparent"
        implicitWidth: 40
        implicitHeight: 40
        x: control.leftPadding
        y: parent.height / 2 - height / 2

        Image {
            anchors.fill: parent
            source: "../res/eye.png"
            sourceSize.width: 128
            sourceSize.height: 128
        }

        Rectangle {
            width: 40
            height: 2
            y: 20
            transform: Rotation {
                origin.x: 20
                origin.y: 1
                angle: -45    
            }
            color: borderColor
            visible: !control.checked
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: fontColor
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
