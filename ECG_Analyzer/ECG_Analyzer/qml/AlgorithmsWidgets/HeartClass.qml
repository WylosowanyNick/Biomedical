import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

Rectangle {
    id: root
    property alias model: model

    width: 300
    height: algoRectHeight1
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
                text: "Classes"
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
                        parameter: "SV/0",
                        value: "value"
                    },
                    {
                        parameter: "V/1",
                        value: "value"
                    },
                    {
                        parameter: "V/2",
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
    }
}