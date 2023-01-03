import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15

Rectangle {
    id: root

    Rectangle {
        id: textFieldRectangle
        color: backgroundColor2
        border.color: borderColor
        border.width: 1
        radius: 5
        
        TextField {
            anchors.fill: parent
            text: slider.value
            color: fontColor
            background: Rectangle{
                radius: 5
                color: "transparent"
            }
        }
    }

    Text {
        id: fromText
        text: "from"
        color: fontColor
        anchors.verticalCenter: textFieldRectangle.verticalCenter
        anchors.right: textFieldRectangle.left
        anchors.rightMargin: 0.04 * parent.width
    }

    Slider {
        id: slider
        from: root.from
        to: root.to
        stepSize: root.stepSize
        value: root.value
        anchors.left: textFieldRectangle.right
        anchors.verticalCenter: textFieldRectangle.verticalCenter
        anchors.leftMargin: 2

        background: Rectangle {
            x: slider.leftPadding
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 0.4 * root.width
            implicitHeight: 2
            width: slider.availableWidth
            height: implicitHeight
            radius: 2
            color: backgroundColor2

            Rectangle {
                width: slider.visualPosition * parent.width
                height: parent.height
                color: borderColor
                radius: 2
            }
        }

        handle: Rectangle {
            x: slider.leftPadding + slider.visualPosition * (slider.availableWidth - width)
            y: slider.topPadding + slider.availableHeight / 2 - height / 2
            implicitWidth: 26
            implicitHeight: 26
            radius: 13
            color: slider.pressed ? buttonColor2 : buttonColor1
            border.color: borderColor
        }
    }
}