import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

Rectangle {
    id: root
    property alias model: model

    width: 300
    height: algoRectHeight
    color: backgroundColor

    ColumnLayout {
        id: content
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor        
        }

        Rectangle {
            Layout.fillWidth: true
            height: 30
            color: backgroundColor2

            Text {
                anchors.centerIn: parent
                text: "Parameters"
                color: fontColor
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor        
        }

        TableView {
            Layout.fillWidth: true
            height: 0.3 * parent.height
            clip: true
            model: TableModel {
                id: model
                TableModelColumn { display: "parameter" }
                TableModelColumn { display: "value" }

                rows: [
                    {
                        parameter: "Alpha 1",
                        value: "value"
                    },
                    {
                        parameter: "Alpha 2",
                        value: "value"
                    }
                ]
            }

            delegate: Rectangle {
                implicitWidth: 150
                implicitHeight: 50
                color: backgroundColor

                Text {
                    text: display
                    color: fontColor
                    anchors.centerIn: parent
                }
            }
        } 
        
        Text {
                text: "Window Size"
                color: fontColor
                Layout.alignment: Qt.AlignHCenter
            }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor
            
            Rectangle {
                id: textFieldRectangle1
                anchors.top : parent.top
                anchors.left: parent.left
                anchors.topMargin: 50
                anchors.leftMargin: 70
                width: parent.width * 0.2
                height: 30
                color: backgroundColor2
                border.color: borderColor
                border.width: 1
                radius: 5
                
                TextField {
                    anchors.fill: parent
                    text: "4"
                    color: fontColor
                    readOnly: true
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
                anchors.verticalCenter: textFieldRectangle1.verticalCenter
                anchors.right: textFieldRectangle1.left
                anchors.rightMargin: 0.04 * parent.width
            }

            Rectangle {
                id: textFieldRectangle2
                anchors.top : textFieldRectangle1.top
                anchors.left: parent.left
                anchors.topMargin: 50
                anchors.leftMargin: 70
                width: parent.width * 0.2
                height: 30
                color: backgroundColor2
                border.color: borderColor
                border.width: 1
                radius: 5
                
                TextField {
                    anchors.fill: parent
                    text: secondSlider.value
                    color: fontColor
                    readOnly: true
                    background: Rectangle{
                        radius: 5
                        color: "transparent"
                    }
                }
            }

            Text {
                id: toText
                text: "to"
                color: fontColor
                anchors.verticalCenter: textFieldRectangle2.verticalCenter
                anchors.right: textFieldRectangle2.left
                anchors.rightMargin: 0.04 * parent.width
            }

            Slider {
                id: secondSlider
                from: 64
                to: 128
                stepSize: 8
                value: 64
                anchors.left: textFieldRectangle2.right
                anchors.verticalCenter: textFieldRectangle2.verticalCenter
                anchors.leftMargin: 2
                onMoved: controller.set_dfa_slider(secondSlider.value)

                background: Rectangle {
                    x: secondSlider.leftPadding
                    y: secondSlider.topPadding + secondSlider.availableHeight / 2 - height / 2
                    implicitWidth: 0.4 * root.width
                    implicitHeight: 2
                    width: secondSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: backgroundColor2

                    Rectangle {
                        width: secondSlider.visualPosition * parent.width
                        height: parent.height
                        color: borderColor
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: secondSlider.leftPadding + secondSlider.visualPosition * (secondSlider.availableWidth - width)
                    y: secondSlider.topPadding + secondSlider.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: secondSlider.pressed ? buttonColor2 : buttonColor1
                    border.color: borderColor
                }
            }
        }

    }
}