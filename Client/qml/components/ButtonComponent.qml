import QtQuick 2.15

// Define a reusable Button component
Component {
    id: buttonComponent

    // property string buttonText;
    // property int buttonTextPixelSize;
    // property int buttonWidth;
    // property int buttonHeight;

    Rectangle {
        width: buttonWidth
        height: buttonHeight
        property string buttonColor: "#34495e"
        property string buttonPressedColor: "#2c3e50"
        property string buttonText: "Play"
        property int buttonTextPixelSize: 24

        signal buttonClicked()

        radius: 12
        color: buttonColor
        border.color: "#000000"
        border.width: 2

        Text {
            anchors.centerIn: parent
            color: "white"
            text: buttonText
            font.pixelSize: buttonTextPixelSize
            font.family: "Roboto"
            font.bold: true
        }

        MouseArea {
            anchors.fill: parent
            onPressed: {
                gameButton.color = buttonPressedColor
            }
            onReleased: {
                gameButton.color = buttonColor
            }
            onClicked: gameButton.buttonClicked()
        }
    }
}
