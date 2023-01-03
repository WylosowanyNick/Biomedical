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

    ColumnLayout{
        id: comboBoxes
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.03
        anchors.left: parent.left
        anchors.leftMargin: parent.width * 0.1
        Layout.fillWidth: true
        spacing: 0.01 * parent.height
        
        Text {
            text: "Baseline Wander Filtration: "
            color: fontColor
        }

        CComboBox {
            id: comboBox1
            onActivated: controller.setBaseline1(index)
            model: ["Butterworth Filter", "Moving Median Filter"]
            Layout.bottomMargin: 0.18 * root.height
            width: root.width * 0.8
        }

        Text {
            text: "Powerline Noise Filtration: "
            color: fontColor
        }

        CComboBox {
            id: comboBox2
            onActivated: controller.setBaseline2(index)
            width: root.width * 0.8
            model: ["IIR Notch Filter", "FIR Filter"]
            Layout.bottomMargin: 0.18 * root.height
        }

        Text {
            text: "Muscle Noise Filtration: "
            color: fontColor
        }

        CComboBox {
            id: comboBox3
            onActivated: controller.setBaseline3(index)
            width: root.width * 0.8
            model: ["Moving Average"]
        }
    }
}
