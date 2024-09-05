import QtQuick 2.15
import "qrc:/qml/components"

Item {
    id: lobbyScreen
    signal backClicked()

    Rectangle {
        id: background
        anchors.fill: parent
        color: "#2f3136"
    }

    Text {
        id: titleText
        font.family: "Roboto"
        font.pixelSize: 56
        font.bold: true
        anchors {
            top: parent.top
            topMargin: 40
            bottomMargin: 10
            horizontalCenter: parent.horizontalCenter
        }
        color: "#FFFFFF"
        text: "Lobby Code: " + gameManager.roomLobbyCode
    }

    GameButton {
        id: backButton
        buttonText: "Quit"
        buttonTextPixelSize: 20
        width: 100
        height: 50
        anchors {
            top: parent.top
            right: parent.right
            topMargin: 52
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
            topMargin: 40
            leftMargin: 40
        }
        width: 240
        height: 460
        border.color: "#6E6E6E"
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

                    source: "qrc:/resources/check.png"
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
            left: roomLobbyListBackground.right
            top: roomLobbyListBackground.top
            bottom: roomLobbyListBackground.bottom
            leftMargin: 20
            rightMargin: 20
            right: parent.right
        }
        border.color: "#6E6E6E"
        border.width: 2
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
        width: 240
        height: 50
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
        buttonTextPixelSize: 28
        width: 120
        height: 50
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
        radius: 10
        color: "#4B4B4B"
        anchors {
            top: readyButton.top
            bottom: readyButton.bottom
            left: messageWindowBackground.left
            right: sendTextButton.left
            rightMargin: 10
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
