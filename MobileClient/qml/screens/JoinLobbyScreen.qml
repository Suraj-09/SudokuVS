import QtQuick 2.15
import "qrc:/qml/components"


Item {
    signal backClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#2f3136"
    }

    Text {
        id: titleText
        font.pixelSize: Math.min(Screen.width, Screen.height) * 0.06
        font.bold: true
        anchors {
            top: parent.top
            topMargin: Screen.height * 0.2
            horizontalCenter: parent.horizontalCenter
        }
        color: "white"
        text: "Enter Game Code"
    }

    Rectangle {
        id: joinLobbyTextBackground
        radius: 5
        color: "#A4A9AD"
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: titleText.bottom
            left: parent.left
            right: parent.right
            topMargin: Screen.height * 0.03
            leftMargin: Screen.width * 0.05
            rightMargin: Screen.width * 0.05
        }
        width: 620
        height: 80
    }

    TextInput {
        id: joinLobbyTextInput
        anchors.fill: joinLobbyTextBackground
        horizontalAlignment: Text.AlignHCenter
        font.bold: true
        font.pixelSize: 48
        color: "black"
        maximumLength: 4
        inputMask: "9999"
        onCursorPositionChanged: {
            // Make sure the cursor is always at the end of the text
            if (text.length === 0) {
                cursorPosition = 0;
            }
        }
    }


    GameButton {
        id: joinGameButton
        anchors {
            top: joinLobbyTextBackground.bottom
            topMargin: 80
            horizontalCenter: parent.horizontalCenter
        }

        buttonText: "Join Game"
        buttonWidth: 180
        buttonHeight: 50
        buttonTextPixelSize: 24
        buttonBold: true
        onButtonClicked: {
            if (joinLobbyTextInput !== "") {
                gameManager.joinLobbyRequest(joinLobbyTextInput.text);
            }
        }
    }

    GameButton {
        id: backButton
        anchors {
            top: joinGameButton.bottom
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }

        buttonText: "Back"
        buttonWidth: 180
        buttonHeight: 50
        buttonTextPixelSize: 24
        buttonBold: true
        onButtonClicked: backClicked()
    }

}

