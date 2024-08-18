import QtQuick 2.15

Item {
    id: lobbyScreen
    signal backClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#2f3136" // Darker background for better contrast
    }

    Text {
        id: titleText
        font.family: "Roboto" // Modern font
        font.pixelSize: 24
        font.bold: true
        anchors {
            top: parent.top
            topMargin: 40
            bottomMargin: 10
            // leftMargin: 80
            horizontalCenter: parent.horizontalCenter
        }
        color: "#FFFFFF"
        text: "Lobby Code: " + gameManager.roomLobbyCode
    }

    GameButton {
        id: backButton
        buttonText: "Back"
        buttonTextPixelSize: 20
        width: 100
        height: 50
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 30
            rightMargin: 20
        }
        onButtonClicked: backClicked()
    }


    Rectangle {
        id: roomLobbyListBackground
        radius: 10
        color: "#4B4B4B"
        anchors {
            top: titleText.bottom
            left: parent.left
            right: parent.right
            topMargin: 40
            leftMargin: 20
            rightMargin: 20
            bottomMargin: 20

        }
        // width: parent.width
        height: (parent.height / 4) - 80
        border.color: "#6E6E6E" // Subtle border for better definition
        border.width: 2

    }

    ListView {
        id: roomLobbyList
        model: gameManager.clientsInLobby
        delegate: Item {
            width: roomLobbyList.width
            height: 60
            Row {
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter

                Text {
                    id: userID
                    text: "Player " + modelData
                    font.pixelSize: 24
                    color: "#FFFFFF"
                    font.bold: true
                }

                Image {
                    id: checkImage
                    visible: gameManager.isClientReady(modelData)

                    Connections {
                        target: gameManager
                        function onReadyClientsListChanged() {
                            checkImage.visible = gameManager.isClientReady(modelData);
                        }
                    }

                    source: "../resources/check.png"
                    width: 30
                    height: 30
                    fillMode: Image.PreserveAspectFit
                }
            }
        }
        anchors.fill: roomLobbyListBackground
    }

    Rectangle {
        id: messageWindowBackground
        radius: 10
        color: "#4B4B4B"
        anchors {
            left: parent.left
            top: roomLobbyListBackground.bottom
            // bottom: roomLobbyListBackground.bottom
            // leftMargin: 20
            // rightMargin: 20
            right: parent.right
            // margin: 20
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
            bottomMargin: 20
        }
        border.color: "#6E6E6E"
        border.width: 2
        height: parent.height / 2
    }

    TextEdit {
        id: messageWindow
        anchors.fill: messageWindowBackground
        font.pixelSize: 20
        color: "#E0E0E0"
        readOnly: true
        padding: 10
    }

    Connections {
        target: gameManager
        function onNewLobbyMessage(message) { messageWindow.append(message) }
    }

    GameButton {
        id: readyButton
        buttonText: "Ready"
        buttonTextPixelSize: 28

        height: 50
        anchors {
            top: sendTextButton.bottom
            left: parent.left
            right: parent.right
            // horizontalCenter: roomLobbyListBackground.horizontalCenter
            topMargin: 20
            leftMargin: 20
            rightMargin: 20
            bottomMargin: 20
        }
        onButtonClicked: gameManager.readyToPlay()
    }

    GameButton {
        id: sendTextButton
        buttonText: "Send"
        buttonTextPixelSize: 28
        width: 120
        height: 50
        anchors {
            top: messageWindowBackground.bottom
            // bottom: readyButton.bottom
            right: messageWindowBackground.right
             // margin: 20
            topMargin: 20
            // leftMargin: 20
            // rightMargin: 20
            // bottomMargin: 20
        }
        onButtonClicked: {
            gameManager.sendMessageToLobby(sendTextInput.text)
            sendTextInput.text = ""
        }
    }

    Rectangle {
        id: sendTextFieldBackground
        radius: 10
        color: "#4B4B4B"
        anchors {
            top: sendTextButton.top
            bottom: sendTextButton.bottom
            left: messageWindowBackground.left
            right: sendTextButton.left
            // rightMargin: 10
             // margin: 20
            // topMargin: 20
            // leftMargin: 20
            rightMargin: 20
            // bottomMargin: 20
        }
        border.color: "#6E6E6E"
        border.width: 2
    }

    TextInput {
        id: sendTextInput
        anchors.fill: sendTextFieldBackground
        anchors.margins: 10
        font.pixelSize: 28
        color: "#000000"
        clip: true
        onAccepted: {
            gameManager.sendMessageToLobby(sendTextInput.text)
            sendTextInput.text = ""
        }
    }
}
