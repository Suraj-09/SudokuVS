import QtQuick 2.15

Rectangle {
    id: gameButton
    property string buttonColor: "#34495e"
    property string buttonPressedColor: "#2c3e50"
    property string buttonText: ""
    property int buttonTextPixelSize: 24
    property int buttonWidth: 100
    property int buttonHeight: 50
    property int buttonRadius: 10
    property bool buttonBold: false

    signal buttonClicked()

    width: buttonWidth
    height: buttonHeight
    radius: buttonRadius
    color: buttonColor


    Text {
        anchors.centerIn: parent
        color: "white"
        text: buttonText
        font.pixelSize: buttonTextPixelSize
        font.family: "Roboto"
        font.bold: buttonBold
    }

    MouseArea {
        anchors.fill: parent
        onPressed: gameButton.color = buttonPressedColor
        onReleased: gameButton.color = buttonColor
        onClicked: gameButton.buttonClicked()
    }

}
