import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

CheckBox {
    id: root
    property int num: -1
    
    padding: 3
    checked: true
    
    contentItem: Text {
        leftPadding: root.indicator.width + root.spacing
        text: root.text
        color: fontColor
    }

    indicator: Rectangle {
        implicitWidth: 20
        implicitHeight: 20
        radius: 3
        color: root.checked ? toggleOn : toggleOff

        Image {
            anchors.fill: parent
            source: "../res/check_mark.png"
            sourceSize.width: 20
            sourceSize.height: 20
            visible: root.checked
        }
    }
}
