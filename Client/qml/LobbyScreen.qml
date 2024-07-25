import QtQuick 2.15

Item {
    id: lobbyScreen

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
        text: "Lobby Code: " + gameManager.roomLobbyCode
    }

    Rectangle {
        id: roomLobbyListBackground
        radius: 5
        color: "#A4A9AD"
        anchors {
            top: titleText.bottom
            left: parent.left
            topMargin: 20
            leftMargin: 40
        }
        width: 358
        height: 418
    }

    ListView {
        id: roomLobbyList
        model: gameManager.clientsInLobby
        delegate: Text {
            id: userID
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Player " + modelData
            font.pixelSize: 36
            color: "white"
            font.bold: true

            Image {
                id: checkImage
                visible: gameManager.isClientReady(modelData)

                Connections {
                    target: gameManager
                    function onReadyClientsListChanged() {
                        checkImage.visible = gameManager.isClientReady(modelData);
                    }
                }

                anchors {
                    left: userID.right
                    leftMargin: 15
                    verticalCenter: userID.verticalCenter
                }

                source: "../resources/check.png"
                width: 40
                height: 40
                fillMode: Image.PreserveAspectFit
            }
        }
        anchors.fill: roomLobbyListBackground
    }


    Rectangle {
        id: messageWindowBackground
        radius: 5
        color: "#A4A9AD"
        anchors {
            // top: titleText.bottom
            left: roomLobbyListBackground.right
            top: roomLobbyListBackground.top
            bottom: roomLobbyListBackground.bottom
            leftMargin: 20
            rightMargin: 40
            right: parent.right
        }
        // width: 358
        // height: 418
    }

    TextEdit {
        id: messageWindow
        anchors.fill: messageWindowBackground
        font.pixelSize: 24
        readOnly: true
    }

    Connections {
        target: gameManager
        function onNewLobbyMessage(message) { messageWindow.append(message) }
    }

    GameButton {
        id: readyButton
        buttonText: "Ready"
        buttonTextPixelSize: 36
        width: 358
        height: 88
        anchors {
            top: roomLobbyListBackground.bottom
            topMargin: 20
            horizontalCenter: roomLobbyListBackground.horizontalCenter
        }

        onButtonClicked: gameManager.readyToPlay()

    }

    GameButton {
        id: sendTextButton
        buttonText: "Send"
        buttonTextPixelSize: 36
        width: 174
        // height: 88
        anchors {
            top: readyButton.top
            bottom: readyButton.bottom
            right: messageWindowBackground.right
        }

        onButtonClicked: {
            gameManager.sendMessageToLobby(sendTextInput.text)
            sendTextInput.text = ""
        }
    }

    Rectangle {
        id: sendTextFieldBackground
        radius: 5
        color: "#A4A9AD"
        anchors {
            top: readyButton.top
            bottom: readyButton.bottom
            left: messageWindowBackground.left
            right: sendTextButton.left
            rightMargin: 20
        }
    }

    TextInput {
        id: sendTextInput
        anchors.fill: sendTextFieldBackground
        anchors.margins: 20
        font.pixelSize: 36
        color: "black"
        clip: true
        onAccepted: {
            gameManager.sendMessageToLobby(sendTextInput.text)
            sendTextInput.text = ""
        }
    }


}
