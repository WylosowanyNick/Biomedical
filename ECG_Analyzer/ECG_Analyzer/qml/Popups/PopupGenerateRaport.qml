import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15

import "../CustomWidgets"

Popup {
    id: root
    width: 600
    height: 400
    property var xAlignment
    property var yAlignment
    x: xAlignment
    y: yAlignment
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
 
        Text {
            id: warning
            anchors.fill: parent
            color: fontColor
            font.pixelSize: 24
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.1
            horizontalAlignment: Text.AlignHCenter
            text: "Generate raport for:"
        }

        RowLayout {
            id: tabs
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            spacing: 50

            ColumnLayout {
                CCheckBox {
                    id: id1
                    text: "R-Peaks"
                }
                CCheckBox {
                    id: id2
                    text: "Waves"
                }
                CCheckBox {
                    id: id3
                    text: "HRV I"
                }
                CCheckBox {
                    id: id4
                    text: "HRV II"
                }
            }

            ColumnLayout {
                CCheckBox {
                    id: id5
                    text: "HRV DFA"
                }
                CCheckBox {
                    id: id6
                    text: "ST Segment"
                }
                CCheckBox {
                    id: id7
                    text: "Heart Class"
                }
                CCheckBox {
                    id: id8
                    text: "Plots"
                }
            }
        }

        Rectangle {
            id: buttonRectangle
            width: parent.width * 0.2
            height: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0.1 * parent.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            CButton {
                id: button
                anchors.fill: buttonRectangle
                text: "Close"
                onClicked: root.close()  
            }
        }

         Rectangle {
            id: buttonRectangle1
            width: parent.width * 0.2
            height: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0.1 * parent.height
            anchors.left: buttonRectangle.right
            anchors.leftMargin: 0.1 * parent.width
            color: "transparent"

            CButton {
                id: button1
                anchors.fill: buttonRectangle1
                text: "Generate"
                onClicked: {
                    let res = 0;
                    if(id1.checked) res |= 0b10000000;
                    if(id2.checked) res |= 0b01000000;
                    if(id3.checked) res |= 0b00100000;
                    if(id4.checked) res |= 0b00010000;
                    if(id5.checked) res |= 0b00001000;
                    if(id6.checked) res |= 0b00000100;
                    if(id7.checked) res |= 0b00000010;
                    if(id8.checked) res |= 0b00000001;

                    controller.setRaport(res);
                    root.close();
                }  
            }
        }
    }
}
