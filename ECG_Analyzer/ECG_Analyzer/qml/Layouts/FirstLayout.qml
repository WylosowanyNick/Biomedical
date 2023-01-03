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
        id: rPeaksWarning
        text: "You have to run \n Baseline algorithm before!"
    }

    PopupError {
        id: wavesWarning
        text: "You have to run \n R Peaks algorithm before!"
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

        // // prostokąty z danymi
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
                case "baseline":
                    val = baseline.vis;
                    break;
                case "rpeaksRow":
                    val = rpeaksRow.vis;
                    break;
                case "wavesRow":
                    val = wavesRow.vis;
            }

            // zwinięcie wszystkich tabów
            baseline.vis = false;
            rpeaksRow.vis = false;
            wavesRow.vis = false;

            // zmiana zwinięcia właściwego
            switch (key) {
                case "baseline":
                    baseline.vis = !val;
                    root.active_alg = baseline.vis ? 1 : 0;
                    controller.setActivatedAlg(root.active_alg)
                    break;
                case "rpeaksRow":
                    rpeaksRow.vis = !val;
                    root.active_alg = rpeaksRow.vis ? 2 : 0;
                    controller.setActivatedAlg(root.active_alg)
                    break;
                case "wavesRow":
                    wavesRow.vis = !val;
                    root.active_alg = wavesRow.vis ? 3 : 0;
                    controller.setActivatedAlg(root.active_alg)
            }
        }

        Layout.alignment: Qt.AlignTop
        spacing: 0

        // logistyka dla switchy zarządzających algorytmów
        ButtonGroup {
            id: switchGroup
            buttons: [baseline.uSwitch, rpeaksRow.uSwitch, wavesRow.uSwitch]
            exclusive: false // switche nie będą wykluczać siebie na wzajem
            onClicked: {
                // okienka ostrzegawcze
                if (button.num == 2 && !baseline.uSwitch.checked && rpeaksRow.uSwitch.checked) {
                    rPeaksWarning.open()
                    button.checked = false
                }
                else if (button.num == 3 && !rpeaksRow.uSwitch.checked && wavesRow.uSwitch.checked) {
                    wavesWarning.open()
                    button.checked = false
                }
                else                
                    controller.setActivatedAlgo1(button.num, button.checked)
            }
        }

        // logistyka dla oczów (tylko jedno może być aktywne w czasie)
        ButtonGroup {
            id: radioGroup
            buttons: [baseline.uEye, rpeaksRow.uEye, wavesRow.uEye]
            onClicked: controller.setActivatedGraph(1, button.num)
        }

        // logistyka dla deaktywacji algorytmów na podstawie deaktywacji baseline, rpeaks albo waves
        Connections {
            target: controller

            function onBaselineDeactivated() {
                // należy deaktywować pozostałe algorytmy tej karty
                rpeaksRow.uSwitch.checked = false;
                wavesRow.uSwitch.checked = false;
            }

            function onRpeaksDeactivated() {
                // należy deaktywować algorytm waves
                wavesRow.uSwitch.checked = false;
            }

            function onGraphChanged(tab_of_graph) {
                if(tab_of_graph == 1) {
                    engine.reload()
                }
            }
        }


        // wiersz Baseline
        CRow {
            id: baseline
            uSwitch.num: 1
            txt: "Baseline"
            mouseArea.onClicked: layout.singleRows("baseline")
            uEye.checked: true
            uEye.num: 1
            loader.source: "../AlgorithmsWidgets/Baseline.qml"
        }

        CRow {
            id: rpeaksRow
            uSwitch.num: 2
            txt: "R-peaks"
            mouseArea.onClicked: layout.singleRows("rpeaksRow")
            uEye.num: 2
        }

        CRow {
            id: wavesRow
            uSwitch.num: 3
            txt: "Waves"
            mouseArea.onClicked: layout.singleRows("wavesRow")
            uEye.num: 3
            loader.source: "../AlgorithmsWidgets/Waves.qml"
        }

        Rectangle {
            width: 300
            height: 1
            color: borderColor
        }
    }
}
