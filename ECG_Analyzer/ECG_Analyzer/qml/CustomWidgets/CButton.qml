import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4

Button {
    id: root
    text: root.text
    background: Rectangle {
        radius: 5
        color: root.down ? buttonColor2 : buttonColor1
    } 
}