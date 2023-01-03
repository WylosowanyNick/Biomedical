import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.15

import "."

ColumnLayout {
    id: root
    property string txt: "default"
    property bool vis: false
    property alias uSwitch: uSwitch
    property alias mouseArea: mouseArea
    property alias uEye: uEye
    property alias loader: pageLoader
    property alias loaderItem: pageLoader.item

    spacing: 0

     Rectangle {
        width: 300
        height: 1
        color: borderColor
    }

    Rectangle {
        id: rect
        width: 300
        height: 60
        color: vis ? backgroundColor2 : backgroundColor

        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }

        RowLayout {
            width: rect.width

            CSwitch {
                id: uSwitch
                Layout.alignment: Qt.AlignLeft
            }

            Text {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignCenter
                horizontalAlignment: Text.AlignHCenter
                text: root.txt
                color: fontColor

            }

            CEye {
                id: uEye
                Layout.alignment: Qt.AlignRight
            }
        }
    }

    Loader {
        id: pageLoader
        visible: vis
    }
}
