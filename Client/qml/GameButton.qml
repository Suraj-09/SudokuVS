import QtQuick 2.15

Rectangle {
    id: gameButton
    property string buttonColor: "#8E8E8E"
    property string buttonPressedColor: "#818181"
    property string buttonText: ""
    property int buttonTextPixelSize: 72

    signal buttonClicked()

    radius: 10
    color: buttonColor
    Text {
        anchors.centerIn: parent
        color: "white"
        text: buttonText
        font.pixelSize: buttonTextPixelSize
    }

    MouseArea {
        anchors.fill: parent
        onPressed: gameButton.color = buttonPressedColor
        onReleased: gameButton.color = buttonColor
        onClicked: gameButton.buttonClicked()
    }

}
