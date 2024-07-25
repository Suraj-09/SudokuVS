import QtQuick 2.15

Item {
    signal backClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#111111"
    }

    Text {
        id: titleText
        font.pixelSize: 72
        font.bold:true
        anchors {
            top: parent.top
            topMargin: 40
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
            topMargin: 100
        }
        width: 620
        height: 80
    }

    TextInput {
        id: joinLobbyTextInput
        anchors.fill: joinLobbyTextBackground
        // anchors.margins: 20
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize: 48
        color: "black"
        maximumLength: 4
        inputMask: "9999"

    }


    GameButton {
        id: joinGameButton
        anchors {
            top: joinLobbyTextBackground.bottom
            topMargin: 40
            horizontalCenter: parent.horizontalCenter
        }

        buttonText: "Join Game"
        width: 336
        height: 105
        buttonTextPixelSize: 48
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
        width: 336
        height: 105
        buttonTextPixelSize: 48
        onButtonClicked: backClicked()
        // onButtonClicked: mainLoader.source = "qml/VersusOptionsPage.qml"
    }

}

