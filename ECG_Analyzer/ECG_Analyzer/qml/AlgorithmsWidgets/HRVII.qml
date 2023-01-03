import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

import "../CustomWidgets"

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
            Layout.fillHeight: true

            model: TableModel {
                id: model
                TableModelColumn { display: "parameter" }
                TableModelColumn { display: "value" }

                rows: [
                    {
                        parameter: "TINN Index",
                        value: "value"
                    },
                    {
                        parameter: "Triangluar Index",
                        value: "value"
                    },
                    {
                        parameter: "Small Elipse\nAxis Length",
                        value: "value"
                    },
                    {
                        parameter: "Large Elipse\nAxis Length",
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
            text: "Show histogram"
            color: fontColor
            Layout.alignment: Qt.AlignHCenter
            Layout.topMargin: parent.height * 0.2
        } 

        CSwitch {
            id: runHistogram
            Layout.alignment: Qt.AlignHCenter
            onClicked: {
                controller.set_hrv_histogram(runHistogram.checked)
            }
        }

        Rectangle {
            color: backgroundColor
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }
}
