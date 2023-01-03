import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Popup {
    id: root
    width: parent.width
    height: parent.height
    modal: true
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        id: windowContent
        anchors.fill: parent
        color: backgroundColor
        opacity: 0.7
        radius: 5

        BusyIndicator {
            id: control
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            running: true
        }
    }
}