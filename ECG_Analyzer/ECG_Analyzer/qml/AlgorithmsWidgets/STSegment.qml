import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15
import Qt.labs.qmlmodels 1.0

Rectangle {
    id: root
    property alias model1: model1
    property alias model2: model2

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
            height: 0.5 * parent.height

            model: TableModel {
                id: model1
                TableModelColumn { display: "parameter" }
                TableModelColumn { display: "value" }

                rows: [
                    {
                        parameter: "Concave",
                        value: "value"
                    },
                    {
                        parameter: "Convex",
                        value: "value"
                    },
                    {
                        parameter: "Horizontal",
                        value: "value"
                    },
                    {
                        parameter: "Downsloping",
                        value: "value"
                    },
                    {
                        parameter: "Upsloping",
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
                text: "Offsets Types"
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

            model: TableModel {
                id: model2
                TableModelColumn { display: "parameter" }
                TableModelColumn { display: "value" }

                rows: [
                    {
                        parameter: "Depression",
                        value: "value"
                    },
                    {
                        parameter: "Elevation",
                        value: "value"
                    },
                    {
                        parameter: "Normal",
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

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor
        } 
    }
}