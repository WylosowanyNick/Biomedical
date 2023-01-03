import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import QtCharts 2.12
import Qt.labs.qmlmodels 1.0

//import QtWebEngine 1.10

import "../CustomWidgets"
import "../Popups"

RowLayout {
    id: root
    property int active_alg: 0 // 0, żadna karta nie została wybrana, 1- pierwsza, 2-druga...

    spacing: 0
    Layout.fillWidth: true
    Layout.fillHeight: true

    PopupError {
        id: warning
        text: "You have to run \nWaves algorithm before!"
    }

    PopupError {
        id: waves
        text: "Waves algorithm have to be run \nwith derivatives method."
    }

    // informacje o danych, wielki prostokąt zawierający wykresy i taby do przełączania zakładek
    ColumnLayout {
        Layout.fillWidth: true

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }

        // informacje o danych
        RowLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 0.1 * parent.width
            Layout.rightMargin: 0.1 * parent.width
            
            Text {
                Layout.preferredWidth: parent.width/3
                color: fontColor
                text: "File Name: " + controller.file_name
            }
            
            Text {
                Layout.preferredWidth: parent.width/3
                color: fontColor
                text: "Sampling Rate: " + controller.sample_rate + "Hz"
            }

            Text {
                Layout.fillWidth: true
                color: fontColor
                text: "Data Comments: " + controller.data_comments
            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            color: borderColor
        }

        // prostokąty z danymi
        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: backgroundColor
            z: 1000

//            WebEngineView {
//                id: engine
//                anchors.fill: parent
//                backgroundColor: '#121212'
//                url: "http://127.0.0.1:9999"
//            }
        }

        Rectangle {
            Layout.fillWidth: true
            height: 1
            z: 1000
            color: borderColor
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            width: parent.width
            color: backgroundColor
            visible: (stSegment.uEye.checked == true && stSegment.vis)

            TableView {
                Layout.fillWidth: true
                height: parent.height
                width: parent.width
                anchors.centerIn: parent
                model: TableModel {
                    id: table
                    TableModelColumn { display: "id" }
                    TableModelColumn { display: "start" }
                    TableModelColumn { display: "end" }
                    TableModelColumn { display: "type" }
                    TableModelColumn { display: "slope" }
                    TableModelColumn { display: "offset" }
                    TableModelColumn { display: "offset_type" }

                    rows: [
                        {
                            id: "",
                            start: "Start",
                            end: "End",
                            type: "Type",
                            slope: "Slope (\^o)",
                            offset: "Offset (mv)",
                            offset_type: "Offset Type"
                        },
                        {
                            id: "1",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "2",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "3",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "4",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "1",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "2",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "3",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        },
                        {
                            id: "4",
                            start: "400",
                            end: "800",
                            type: "concave",
                            slope: "12",
                            offset: "14",
                            offset_type: "depression"
                        }
                    ]
                }

                delegate: Rectangle {
                    id: item
                    implicitWidth: (window.width-300)/7
                    implicitHeight: 50
                    color: backgroundColor

                    Text {
                        text: display
                        color: fontColor
                        anchors.centerIn: parent
                    }
                }

                ScrollBar.vertical: ScrollBar {
                    id: scroll
                    width: 10

                    contentItem: Rectangle {
                        implicitWidth: 10
                        implicitHeight: parent.height
                        radius: width / 2
                        color: scroll.pressed ? buttonColor2 : buttonColor1
                    }
                }
            }
        }
        Rectangle {
            Layout.fillWidth: true
            height: 50
            color: backgroundColor
            z: 1000
        }
    }

    Rectangle {
        Layout.fillHeight: true
        width: 1
        color: borderColor
    }

    // wybory algorytmów po prawej stronie
    ColumnLayout {
        id: layout

        // logistyka dla rozwijania i zwijania tabów
        function singleRows(key)
        {
            // zapamiętanie wartości rozwijanego/zwijanego taba
            let val = true;
            switch (key) {
                case "stSegment":
                    val = stSegment.vis;
                    break;
                case "heartClass":
                    val = heartClass.vis;
            }

            // zwinięcie wszystkich tabów
            stSegment.vis = false;
            heartClass.vis = false;

            // zmiana zwinięcia właściwego
            switch (key) {
                case "stSegment":
                    stSegment.vis = !val;
                    root.active_alg = stSegment.vis ? 1 : 0;
                    controller.setActivatedAlg(root.active_alg)
                    break;
                case "heartClass":
                    heartClass.vis = !val;
                    root.active_alg = heartClass.vis ? 2 : 0;
                    controller.setActivatedAlg(root.active_alg)
            }
        }

        Layout.alignment: Qt.AlignTop
        spacing: 0

        // logistyka dla switchy zarządzających algorytmów
        ButtonGroup {
            id: switchGroup
            buttons: [stSegment.uSwitch, heartClass.uSwitch]
            exclusive: false // switche nie będą wykluczać siebie na wzajem
            onClicked: {
                // okienka ostrzegawcze
                if (button.num == 1 && !controller.getActivatedAlgo1(3) && stSegment.uSwitch.checked) {
                    warning.open()
                    button.checked = false
                }

                else if (button.num == 1 && controller.getActivatedAlgo1(3) && stSegment.uSwitch.checked && controller.getWaves1() == 0) {
                    waves.open()
                    button.checked = false
                }

                else if (button.num == 2 && !controller.getActivatedAlgo1(3) && heartClass.uSwitch.checked) {
                    warning.open()
                    button.checked = false
                }
                else
                    controller.setActivatedAlgo3(button.num, button.checked)
                }
        }

        // logistyka dla oczów (tylko jedno może być aktywne w czasie)
        ButtonGroup {
            id: radioGroup
            buttons: [stSegment.uEye, heartClass.uEye]
            onClicked: controller.setActivatedGraph(3, button.num)
        }

        // logistyka dla deaktywacji algorytmów na podstawie deaktywacji baseline, rpeaks albo waves
        Connections {
            target: controller

            function onBaselineDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                // ponieważ waves działa na rpeaks, który działa na baseline
                stSegment.uSwitch.checked = false;
                heartClass.uSwitch.checked = false;
            }

            function onRpeaksDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                // ponieważ waves działa na rpeaks
                stSegment.uSwitch.checked = false;
                heartClass.uSwitch.checked = false;
            }

            function onWavesDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                // ponieważ działają one na waves
                stSegment.uSwitch.checked = false;
                heartClass.uSwitch.checked = false;
            }
            
            function onGraphChanged(tab_of_graph) {
                if(tab_of_graph == 3) {
                    engine.reload()
                }
            }

            function onTabularChanged(tab_of_tabular, tabular_index) {
                // aktualizowanie wartości tabelarycznych, gdy algorytm jest aktywowany
                if (tab_of_tabular == 3)
                switch (tabular_index) {
                    case 1:
                        var l = controller.getStSegment()
                        table.clear()        
                        for(var i=0; i<l.length; i++) {
                            table.appendRow({
                                id: l[i][0],
                                start: l[i][1],
                                end: l[i][2],
                                type: l[i][3],
                                slope: l[i][4],
                                offset: l[i][5],
                                offset_type: l[i][6]
                            })
                        }

                        var l = controller.getStSegmentClasses()
                        for(var i=0; i<l.length; i++) {
                            stSegment.loaderItem.model1.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }

                        var l = controller.getStSegmentOffsets()
                        for(var i=0; i<l.length; i++) {
                            stSegment.loaderItem.model2.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }
                        break;
                    case 2:
                        var l = controller.getHeartClass()
                        for(var i=0; i<l.length; i++) {
                            heartClass.loaderItem.model.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }
                        break;
                }
            }
        }

        // wiersz Baseline
        CRow {
            id: stSegment
            uSwitch.num: 1
            txt: "ST Segment"
            mouseArea.onClicked: layout.singleRows("stSegment")
            uEye.checked: true
            uEye.num: 1
            loader.source: "../AlgorithmsWidgets/STSegment.qml"
        }

        CRow {
            id: heartClass
            uSwitch.num: 2
            txt: "Heart Class"
            mouseArea.onClicked: layout.singleRows("heartClass")
            uEye.num: 2
            loader.source: "../AlgorithmsWidgets/HeartClass.qml"
        }

        Rectangle {
            width: 300
            height: 1
            color: borderColor
        }
    }
}
