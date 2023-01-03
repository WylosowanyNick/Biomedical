import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15

import "../CustomWidgets"

Popup {
    id: root
    width: 500
    height: 500
    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    modal: true
    closePolicy: Popup.NoAutoClose
    property string text

    background: Rectangle {
        id: windowContent
        anchors.fill: parent
        color: backgroundColor
        border.width: 1
        border.color: borderColor
        radius: 5

        Rectangle {
            id: imageRectangle
            width: 0.2 * parent.width
            height: 0.2 * parent.height
            color: backgroundColor
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
            Image {
                anchors.fill: parent
                source: "../res/warning.png"
                sourceSize.width: 100
                sourceSize.height: 100
            }
        }
        
        Text {
            id: warning
            anchors.fill: parent
            color: fontColor
            font.pixelSize: 24
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: root.text
        }

        Rectangle {
            id: buttonRectangle
            width: parent.width * 0.3
            height: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0.1 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            CButton {
                id: button
                anchors.fill: buttonRectangle
                text: "Ok"
                onClicked: root.close()  
            }
        }
    }
}
