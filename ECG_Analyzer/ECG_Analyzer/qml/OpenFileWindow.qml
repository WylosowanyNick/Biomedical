import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.3

import "CustomWidgets"
import "Popups"

Window {
    id: root
    property var path: ""
    property var signal_length: 0
    property var sample_rate: 0
    title: qsTr("Open File")
    width: 800
    height: 500
    maximumHeight : 720
    maximumWidth : 1280
    minimumHeight : 400
    minimumWidth : 700
    visible: false

    Rectangle {
        id: windowContent
        anchors.fill: parent
        color: backgroundColor

        PopupError {
            id: sliderWarning
            width: 400
            height: 400
            text: "Value of the first slider \n can not be larger than \n value of second slider!"
        }

        Rectangle {
            id: upperRectangle
            anchors.top: parent.top
            width: parent.width
            height: parent.height * 0.3
            color: backgroundColor

            Text {
                text: "File Directory"
                color: fontColor
                anchors.bottom: textFieldRectangle.top
                anchors.bottomMargin: 5
                anchors.left: upperRectangle.left
                anchors.leftMargin: 0.05 * parent.width
            }

            Rectangle {
                id: textFieldRectangle 
                anchors.top: upperRectangle.top
                anchors.topMargin: 0.4 * parent.height
                anchors.left: upperRectangle.left
                anchors.leftMargin: 0.05 * parent.width
                width: parent.width * 0.7
                height: 30
                color: backgroundColor2
                border.color: borderColor
                border.width: 1
                radius: 5
                
                TextField {
                    id: pathTextField
                    anchors.fill: parent
                    text: path
                    font.pointSize: 13
                    color: fontColor
                    background: Rectangle{
                        radius: 5
                        color: "transparent"
                    }
                }
            }

            Rectangle {
                id: buttonRectangle
                width: parent.width * 0.1
                height: 30
                anchors.top: upperRectangle.top
                anchors.topMargin: 0.4 * parent.height
                anchors.right: parent.right
                anchors.rightMargin: 0.05 * parent.width
                color: "transparent"

                CButton {
                    id: button1
                    anchors.fill: buttonRectangle
                    text: "Browse"
                    onClicked: fileDialog.open()
                }

                 FileDialog {
                    id: fileDialog
                    title: "Please choose a file"
                    nameFilters: ["Data files (*.dat)"]
                    folder: shortcuts.home
                    onAccepted: {
                        path = fileDialog.fileUrl.toString().replace(/^(file:\/{3})|(qrc:\/{2})|(http:\/{2})/,"");
                        cleanPath: decodeURIComponent(path)
                        signal_length = controller.get_slider_signal_length(path)
                        sample_rate = controller.get_slider_sample_rate(path)
                        controller.set_path(path)
                        console.log("You chose: " + path)
                    }
                    onRejected: {
                        console.log("Canceled")
                    }
                }
            }
        }
            

         Rectangle {
            id: upperSeparator
            anchors.top: upperRectangle.bottom
            width: parent.width
            height: 1
            color: borderColor
        }

        Rectangle {
            id: separator
            anchors.top: upperSeparator.bottom
            width: parent.width
            height: 8
            color: backgroundColor2
        }

         Rectangle {
            id: bottomSeparator
            anchors.top: separator.bottom
            width: parent.width
            height: 1
            color: borderColor
        }

        Rectangle {
            id: bottomRectangle
            anchors.top: bottomSeparator.bottom
            width: parent.width
            height: parent.height * 0.7 - 10
            color: backgroundColor

            CheckBox {
                id: chooseSubset
                anchors.left: bottomRectangle.left
                anchors.leftMargin: 0.05 * parent.width
                anchors.top: bottomRectangle.top
                anchors.topMargin: 0.2 * upperRectangle.height
                checked: false
                text: "Choose Subset"
                visible: path == "" ? false : true
                
                contentItem: Text {
                    leftPadding: chooseSubset.indicator.width + chooseSubset.spacing
                    text: chooseSubset.text
                    color: fontColor
                }

                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 3
                    color: backgroundColor2

                    Image {
                        anchors.fill: parent
                        source: "res/check_mark.png"
                        sourceSize.width: 26
                        sourceSize.height: 26
                        visible: chooseSubset.checked
                    }
                }
            }

            Rectangle {
                id: textFieldRectangle1 
                anchors.top: chooseSubset.bottom
                anchors.topMargin: 0.1 * parent.height
                anchors.left: bottomRectangle.left
                anchors.leftMargin: 0.2 * parent.width
                width: parent.width * 0.1
                height: 30
                color: backgroundColor2
                border.color: borderColor
                border.width: 1
                radius: 5
                visible: chooseSubset.checked
                
                TextField {
                    anchors.fill: parent
                    text: path == "" ? "" : new Date((firstSlider.value/sample_rate) * 1000).toISOString().substr(11, 8)
                    color: fontColor
                    visible: chooseSubset.checked
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
                anchors.rightMargin: 0.01 * parent.width
                visible: chooseSubset.checked
            }

            Slider {
                id: firstSlider
                from: 0
                to: signal_length - 10000
                value: 0
                stepSize: 1
                anchors.left: textFieldRectangle1.right
                anchors.verticalCenter: textFieldRectangle1.verticalCenter
                anchors.leftMargin: 2
                visible: chooseSubset.checked

                background: Rectangle {
                    x: firstSlider.leftPadding
                    y: firstSlider.topPadding + firstSlider.availableHeight / 2 - height / 2
                    implicitWidth: 0.25 * root.width
                    implicitHeight: 2
                    width: firstSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: backgroundColor2

                    Rectangle {
                        width: firstSlider.visualPosition * parent.width
                        height: parent.height
                        color: borderColor
                        radius: 2
                    }
                }

                handle: Rectangle {
                    x: firstSlider.leftPadding + firstSlider.visualPosition * (firstSlider.availableWidth - width)
                    y: firstSlider.topPadding + firstSlider.availableHeight / 2 - height / 2
                    implicitWidth: 26
                    implicitHeight: 26
                    radius: 13
                    color: firstSlider.pressed ? buttonColor2 : buttonColor1
                    border.color: borderColor
                }
            }

            Rectangle {
                id: textFieldRectangle2 
                anchors.top: textFieldRectangle1.bottom
                anchors.topMargin: 0.1 * parent.height
                anchors.left: textFieldRectangle1.left
                width: parent.width * 0.1
                height: 30
                color: backgroundColor2
                border.color: borderColor
                border.width: 1
                radius: 5
                visible: chooseSubset.checked
                
                TextField {
                    anchors.fill: parent
                    text: path == "" ? "" : new Date((secondSlider.value/sample_rate) * 1000).toISOString().substr(11, 8)
                    color: fontColor
                    visible: chooseSubset.checked
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
                anchors.rightMargin: 0.01 * parent.width
                visible: chooseSubset.checked
            }

            Slider {
                id: secondSlider
                from: 10000
                to: signal_length
                value: signal_length
                stepSize: 1
                anchors.left: textFieldRectangle2.right
                anchors.verticalCenter: textFieldRectangle2.verticalCenter
                anchors.leftMargin: 2
                visible: chooseSubset.checked

                background: Rectangle {
                    x: secondSlider.leftPadding
                    y: secondSlider.topPadding + secondSlider.availableHeight / 2 - height / 2
                    implicitWidth: 0.25 * root.width
                    implicitHeight: 2
                    width: secondSlider.availableWidth
                    height: implicitHeight
                    radius: 2
                    color: borderColor

                    Rectangle {
                        width: secondSlider.visualPosition * parent.width
                        height: parent.height
                        color: backgroundColor2
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

            Rectangle {
                id: buttonRectangle1
                width: parent.width * 0.1
                height: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0.2 * parent.height
                anchors.right: parent.right
                anchors.rightMargin: 0.05 * parent.width
                color: "transparent"

                CButton {
                    id: button2
                    anchors.fill: buttonRectangle1
                    text: "Load"
                    onClicked: {
                        if(firstSlider.value > secondSlider.value) {
                            sliderWarning.open()
                        }

                        else {
                            if(chooseSubset.checked) {
                                console.log(firstSlider.value)
                                console.log(secondSlider.value)
                                path = pathTextField.text
                                controller.load_file(path, firstSlider.value, secondSlider.value)
                            }
                            else {
                                path = pathTextField.text
                                controller.load_file(path, 0, signal_length)
                            }
                            root.close() 
                        }
                    }
                }
            }

             Rectangle {
                id: buttonRectangle2
                width: parent.width * 0.1
                height: 30
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0.2 * parent.height
                anchors.right: buttonRectangle1.left
                anchors.rightMargin: 0.05 * parent.width
                color: "transparent"

                CButton {
                    id: button3
                    anchors.fill: buttonRectangle2
                    text: "Cancel"
                    onClicked: root.close()  
                }
            }
        }
    }
}
