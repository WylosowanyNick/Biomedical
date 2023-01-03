import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12

import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3
import QtQuick.Layouts 1.15
import QtCharts 2.12

//import QtWebEngine 1.10

import "qml"
import "qml/CustomWidgets"
import "qml/Layouts"
import "qml/Popups"

ApplicationWindow {
    id: window
    property var backgroundColor: "#121212"
    property var backgroundColor2: "#363636"
    property var fontColor: "#9c9c9c"
    property var borderColor: "#9c9c9c"
    property var buttonColor1: "#008CFF"
    property var buttonColor2: "#006fca"
    property var toggleOn: "#36B37E"
    property var toggleOff: "#9c9c9c"
    property var algoRectHeight: window.height - 223
    property var algoRectHeight1: window.height - 162
    property var currentIndex: 0
    width: 1280
    height: 720
    minimumHeight : 720
    minimumWidth : 1280
    visible: true
    title: qsTr("DADM Projekt")
    
    Rectangle {
        id: content
        anchors.fill: parent
        color: backgroundColor

        // pasek menu
        MainMenuBar {
            id: menubar
            xPopupAlignment: (parent.width - 600) / 2
            yPopupAlignment: (parent.height - 400) / 2
        }

        StackLayout {
            id: contentLayout
            anchors.top: menubar.bottom
            anchors.bottom: parent.bottom 
            anchors.right: parent.right
            anchors.left: parent.left
            currentIndex: 0

            PopupBusyIndicator {
                id: popupBusyIndicator
                visible: controller.algorythmIsRunning
            }
        
            FirstLayout {
                id: firstLayout
            }

            SecondLayout {
                id: secondLayout
            }

            ThirdLayout {
                id: thirdLayout
            }
        }
    }

    RowLayout {
        id: tabs
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        anchors.bottom: content.bottom
        anchors.horizontalCenter: content.horizontalCenter
        CRadioButton {
            checked: true
            text: "I"
            onClicked: {
                contentLayout.currentIndex = 0;
                controller.setActivatedTab(1);
                controller.setActivatedAlg(firstLayout.active_alg);
            }
        }
        
        CRadioButton {
            text: "II"
            onClicked: {
                contentLayout.currentIndex = 1;
                controller.setActivatedTab(2);
                controller.setActivatedAlg(secondLayout.active_alg);
            }
        }
        
        CRadioButton {
            text: "III"
            onClicked: {
                contentLayout.currentIndex = 2;
                controller.setActivatedTab(3);
                controller.setActivatedAlg(thirdLayout.active_alg);
            }
        }
    }
}
 
