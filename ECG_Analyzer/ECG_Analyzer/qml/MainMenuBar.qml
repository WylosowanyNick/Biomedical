import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

import "Popups"

MenuBar {
    id: root
    property var xPopupAlignment
    property var yPopupAlignment
    background: Rectangle {
        color: backgroundColor
    }

    OpenFileWindow {
        id: openFileWindow
    }

    PopupGenerateRaport {
        id: popupGenerateRaport
        xAlignment: xPopupAlignment
        yAlignment: yPopupAlignment
    }

    Menu {
        id: menu
        title: qsTr("File")
        Action { 
            text: qsTr("Open")
            onTriggered: openFileWindow.show()
        }
        Action { 
            text: qsTr("Generate Raport")
            onTriggered: popupGenerateRaport.open()
        }
        Action { 
            text: qsTr("Quit")
            onTriggered: Qt.quit()
        }

        delegate: MenuItem {
            id: menuItem
            implicitWidth: 200
            implicitHeight: 40
            contentItem: Text {
                leftPadding: menuItem.indicator.width
                rightPadding: menuItem.arrow.width
                text: menuItem.text
                opacity: enabled ? 1.0 : 0.3
                color: fontColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: menuItem.highlighted ? backgroundColor2 : backgroundColor
                border.color: borderColor
                border.width: 1
            }
        }
    }

    // Menu {
    //     id: menu2
    //     title: qsTr("Options")
    //     Action { 
    //         text: qsTr("Original Signal visibility:")
    //         // onTriggered: openFileWindow.show()
    //     }

    //     delegate: MenuItem {
    //         id: menuItem
    //         implicitWidth: 400
    //         implicitHeight: 40
    //         contentItem: Text {
    //             leftPadding: menuItem.indicator.width
    //             rightPadding: menuItem.arrow.width
    //             text: menuItem.text
    //             opacity: enabled ? 1.0 : 0.3
    //             color: fontColor
    //             horizontalAlignment: Text.AlignLeft
    //             verticalAlignment: Text.AlignVCenter
    //         }

    //         background: Rectangle {
    //             implicitWidth: 400
    //             implicitHeight: 40
    //             color: backgroundColor
    //             border.color: borderColor
    //             border.width: 1

    //             UCheckBox {
    //                 id: checkBox
    //                 anchors.right: parent.right
    //                 anchors.rightMargin: 5
    //                 anchors.verticalCenter: parent.verticalCenter
    //                 checked: true
    //                 onClicked: {
    //                     controller.set_original_signal_visibility(checkBox.checked)
    //                 }
    //             }
    //         }
    //     }
    // }

    Menu {
        id: menu3
        title: qsTr("Help")
        Action { 
            text: qsTr("Documentation")
            onTriggered: Qt.openUrlExternally('https://student.agh.edu.pl/~kaczmars/DADM-docs/')
        }
        
        delegate: MenuItem {
            id: menuItem2
            implicitWidth: 200
            implicitHeight: 40
            contentItem: Text {
                leftPadding: menuItem2.indicator.width
                rightPadding: menuItem2.arrow.width
                text: menuItem2.text
                opacity: enabled ? 1.0 : 0.3
                color: fontColor
                horizontalAlignment: Text.AlignLeft
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }

            background: Rectangle {
                implicitWidth: 200
                implicitHeight: 40
                color: menuItem2.highlighted ? backgroundColor2 : backgroundColor
                border.color: borderColor
                border.width: 1
            }
        }
    }

    delegate: MenuBarItem {
        id: menuBarItem

        contentItem: Text {
            text: menuBarItem.text
            color: fontColor
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            implicitHeight: 40
            opacity: enabled ? 1 : 0.3
            color: menuBarItem.highlighted ? backgroundColor2 : backgroundColor

            Rectangle {
                height: 40
                width: 1
                color: borderColor
                anchors.right: parent.left
            }

            Rectangle {
                height: 40
                width: 1
                color: borderColor
                anchors.left: parent.right
            }
        }
    }
}  
