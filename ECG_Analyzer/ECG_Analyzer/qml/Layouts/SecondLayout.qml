import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import QtCharts 2.12

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
        id: hrvWarning
        text: "You have to run \nR Peaks algorithm before!"
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

//            WebEngineView {
//                id: engine
//                anchors.fill: parent
//                backgroundColor: '#121212'
//                url: "http://127.0.0.1:9999"
//            }
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
                case "hrvI":
                    val = hrvI.vis;
                    break;
                case "hrvII":
                    val = hrvII.vis;
                    break;
                case "hrvDFA":
                    val = hrvDFA.vis;
            }

            // zwinięcie wszystkich tabów
            hrvI.vis = false;
            hrvII.vis = false;
            hrvDFA.vis = false;

            // zmiana zwinięcia właściwego
            switch (key) {
                case "hrvI":
                    hrvI.vis = !val;
                    root.active_alg = hrvI.vis ? 1 : 0;
                    controller.setActivatedAlg(root.active_alg)
                    break;
                case "hrvII":
                    hrvII.vis = !val;
                    root.active_alg = hrvII.vis ? 2 : 0;
                    controller.setActivatedAlg(root.active_alg)
                    break;
                case "hrvDFA":
                    hrvDFA.vis = !val;
                    root.active_alg = hrvDFA ? 3 : 0;
                    controller.setActivatedAlg(root.active_alg)
            }
        }

        Layout.alignment: Qt.AlignTop
        spacing: 0

        // logistyka dla switchy zarządzających algorytmów
        ButtonGroup {
            id: switchGroup
            buttons: [hrvI.uSwitch, hrvII.uSwitch, hrvDFA.uSwitch]
            exclusive: false // switche nie będą wykluczać siebie na wzajem
            onClicked: {
                // okienka ostrzegawcze
                if (button.num == 1 && !controller.getActivatedAlgo1(2) && hrvI.uSwitch.checked) {
                    hrvWarning.open()
                    button.checked = false
                }

                else if (button.num == 2 && !controller.getActivatedAlgo1(2) && hrvII.uSwitch.checked) {
                    hrvWarning.open()
                    button.checked = false
                }

                else if (button.num == 3 && !controller.getActivatedAlgo1(2) && hrvDFA.uSwitch.checked) {
                    hrvWarning.open()
                    button.checked = false
                }
                else
                    controller.setActivatedAlgo2(button.num, button.checked)
            }
        }

        // logistyka dla oczów (tylko jedno może być aktywne w czasie)
        ButtonGroup {
            id: radioGroup
            buttons: [hrvI.uEye, hrvII.uEye, hrvDFA.uEye]
            onClicked: controller.setActivatedGraph(2, button.num)
        }

        // logistyka dla deaktywacji algorytmów na podstawie deaktywacji baseline, rpeaks albo waves
        Connections {
            target: controller

            function onBaselineDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                // ponieważ rpeaks działa na baseline
                hrvI.uSwitch.checked = false;
                hrvII.uSwitch.checked = false;
                hrvDFA.uSwitch.checked = false;
            }

            function onRpeaksDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                hrvI.uSwitch.checked = false;
                hrvII.uSwitch.checked = false;
                hrvDFA.uSwitch.checked = false;
            }
            
            function onGraphChanged(tab_of_graph) {
                if(tab_of_graph == 2) {
                    engine.reload()
                }
            }

            function onTabularChanged(tab_of_tabular, tabular_index)
            {
                // aktualizowanie wartości tabelarycznych, gdy algorytm jest aktywowany
                if(tab_of_tabular == 2)
                switch (tabular_index) {
                    case 1:
                        var l = controller.getHrvI()
                        for(var i=0; i<l.length; i++) {
                            hrvI.loaderItem.model.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }
                        break;
                    case 2:
                        var l = controller.getHrvII()
                        for(var i=0; i<l.length; i++) {
                            hrvII.loaderItem.model.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }
                        break;
                    case 3:
                        var l = controller.getHrvDfa()
                        for(var i=0; i<l.length; i++) {
                            hrvDFA.loaderItem.model.setRow(i, {
                                parameter: l[i][0], value: l[i][1]
                            })
                        }
                }
            }
        }

        CRow {
            id: hrvI
            uSwitch.num: 1
            txt: "HRV I"
            mouseArea.onClicked: layout.singleRows("hrvI")
            uEye.checked: true
            uEye.num: 1
            loader.source: "../AlgorithmsWidgets/HRVI.qml"
        }

        CRow {
            id: hrvII
            uSwitch.num: 2
            txt: "HRV II"
            mouseArea.onClicked: layout.singleRows("hrvII")
            uEye.num: 2
            loader.source: "../AlgorithmsWidgets/HRVII.qml"
        }

        CRow {
            id: hrvDFA
            uSwitch.num: 3
            txt: "HRV DFA"
            mouseArea.onClicked: layout.singleRows("hrvDFA")
            uEye.num: 3
            loader.source: "../AlgorithmsWidgets/HRVDFA.qml"
        }

        Rectangle {
            width: 300
            height: 1
            color: borderColor
        }
    }
}
