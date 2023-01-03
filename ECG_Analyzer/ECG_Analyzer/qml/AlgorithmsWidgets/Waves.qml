import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15

import "../CustomWidgets"

Rectangle {
    id: root
    width: 300
    height: algoRectHeight
    color: backgroundColor

    CComboBox {
        id: comboBox
        onActivated: controller.setWaves1(index)
        model: ["Derivatives", "Discreate Wavelet Transform"]
        anchors.horizontalCenter: root.horizontalCenter
        anchors.top: root.top
        anchors.topMargin: root.height * 0.1
    }

    StackLayout {
        id: layout
        currentIndex: comboBox.currentIndex

        anchors.top: comboBox.bottom
        anchors.topMargin: root.height * 0.1
        anchors.left: root.left
        anchors.leftMargin: 20
        anchors.right: root.right
        anchors.bottom: root.bottom
        Layout.fillWidth: true
        Layout.fillHeight: true

    }
}
