import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
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
        font.pixelSize: Math.min(Screen.width, Screen.height) * 0.06
        font.bold: true
        anchors {
            top: parent.top
            topMargin: Screen.height * 0.04
            leftMargin: Screen.height * 0.02

        }
        color: "#FFFFFF"
        text: "Lobby Code: " + gameManager.roomLobbyCode
    }

    GameButton {
        id: backButton
        buttonText: "Back"
        buttonTextPixelSize: Math.min(Screen.width, Screen.height) * 0.06
        width: Screen.width * 0.25
        height: Screen.height * 0.06
        anchors {
            top: parent.top
            right: parent.right
            topMargin: Screen.height * 0.03
            rightMargin: Screen.width * 0.05
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
            topMargin: Screen.height * 0.03
            leftMargin: Screen.width * 0.05
            rightMargin: Screen.width * 0.05
        }
        height: Screen.height * 0.2
        border.color: "#6E6E6E"
        border.width: 2
    }

    ListView {
        id: roomLobbyList
        model: gameManager.clientsInLobby
        delegate: Item {
            width: roomLobbyList.width
            height: roomLobbyListBackground.height * 0.25

            Row {
                spacing: 20

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    verticalCenter: parent.verticalCenter
                }



                Text {
                    id: userID
                    text: "Player " + modelData
                    font.pixelSize: roomLobbyList.height * 0.15
                    color: "#FFFFFF"
                    font.bold: true
                }

                Image {
                    id: checkImage
                    visible: gameManager.isClientReady(modelData)
                    source: "qrc:/resources/check.png"
                    width: Screen.height * 0.05
                    height: Screen.height * 0.05
                    fillMode: Image.PreserveAspectFit
                    onVisibleChanged: console.log("Check image visibility changed:", visible, "\ngameManager.isClientReady(modelData)", gameManager.isClientReady(modelData))
                }
            }
        }
        anchors.fill: roomLobbyListBackground
    }

    // Rectangle {
    //     id: messageWindowBackground
    //     radius: 10
    //     color: "#4B4B4B"
    //     anchors {
    //         top: roomLobbyListBackground.bottom
    //         left: parent.left
    //         right: parent.right
    //         topMargin: Screen.height * 0.03
    //         leftMargin: Screen.width * 0.05
    //         rightMargin: Screen.width * 0.05
    //     }
    //     height: Screen.height * 0.35
    //     border.color: "#6E6E6E"
    //     border.width: 2
    // }

    // TextEdit {
    //     id: messageWindow
    //     anchors.fill: messageWindowBackground
    //     font.pixelSize: Math.min(Screen.width, Screen.height) * 0.05
    //     color: "#E0E0E0"
    //     readOnly: true
    //     wrapMode: Text.Wrap   // Ensure text wraps within the bounds
    //     verticalScrollBarPolicy: Qt.ScrollBarAsNeeded
    //     horizontalScrollBarPolicy: Qt.ScrollBarAsNeeded
    // }

    Rectangle {
        id: messageWindowBackground
        radius: 10
        color: "#4B4B4B"
        anchors {
            top: roomLobbyListBackground.bottom
            left: parent.left
            right: parent.right
            topMargin: Screen.height * 0.03
            leftMargin: Screen.width * 0.05
            rightMargin: Screen.width * 0.05
        }
        height: Screen.height * 0.35
        border.color: "#6E6E6E"
        border.width: 2

        ScrollView {
            anchors.fill: parent
            TextEdit {
                id: messageWindow
                width: parent.width
                font.pixelSize: Math.min(Screen.width, Screen.height) * 0.05
                color: "#E0E0E0"
                readOnly: true
                wrapMode: Text.Wrap
                // Optionally set a fixed height if needed
                // height: parent.height
            }
        }
    }


    Connections {
        target: gameManager
        function onNewLobbyMessage(message) {
            messageWindow.append(message)
            messageWindow.verticalScrollBarPosition = 1.0
        }
    }

    GameButton {
        id: sendTextButton
        buttonText: "Send"
        buttonTextPixelSize: Math.min(Screen.width, Screen.height) * 0.06
        width: Screen.width * 0.3
        height: Screen.height * 0.08
        anchors {
            top: messageWindowBackground.bottom
            right: messageWindowBackground.right
            topMargin: Screen.height * 0.03
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
            rightMargin: Screen.width * 0.05
        }
        border.color: "#6E6E6E"
        border.width: 2
    }

    TextInput {
        id: sendTextInput
        anchors.fill: sendTextFieldBackground
        anchors.margins: 10
        font.pixelSize: Math.min(Screen.width, Screen.height) * 0.03
        color: "#000000"
        clip: true
        onAccepted: {
            gameManager.sendMessageToLobby(sendTextInput.text)
            sendTextInput.text = ""
        }
    }

    GameButton {
        id: readyButton
        buttonText: "Ready"
        buttonTextPixelSize: Math.min(Screen.width, Screen.height) * 0.06
        height: Screen.height * 0.08
        anchors {
            top: sendTextButton.bottom
            left: parent.left
            right: parent.right
            topMargin: Screen.height * 0.03
            leftMargin: Screen.width * 0.05
            rightMargin: Screen.width * 0.05
            bottomMargin: Screen.height * 0.03
        }
        onButtonClicked: gameManager.readyToPlay()
    }
}


// import QtQuick 2.15
// import "qrc:/qml/components"


// Item {
//     id: lobbyScreen
//     signal backClicked()

//     Rectangle {
//         id: background
//         anchors.fill: parent
//         color: "#2f3136"
//     }

//     Text {
//         id: titleText
//         font.family: "Roboto"
//         font.pixelSize: 24
//         font.bold: true
//         anchors {
//             top: parent.top
//             topMargin: 40
//             bottomMargin: 10
//             // leftMargin: 80
//             horizontalCenter: parent.horizontalCenter
//         }
//         color: "#FFFFFF"
//         text: "Lobby Code: " + gameManager.roomLobbyCode
//     }

//     GameButton {
//         id: backButton
//         buttonText: "Back"
//         buttonTextPixelSize: 20
//         width: 100
//         height: 50
//         anchors {
//             top: parent.top
//             right: parent.right
//             topMargin: 30
//             rightMargin: 20
//         }
//         onButtonClicked: backClicked()
//     }


//     Rectangle {
//         id: roomLobbyListBackground
//         radius: 10
//         color: "#4B4B4B"
//         anchors {
//             top: titleText.bottom
//             left: parent.left
//             right: parent.right
//             topMargin: 40
//             leftMargin: 20
//             rightMargin: 20
//             bottomMargin: 20

//         }
//         // width: parent.width
//         height: (parent.height / 4) - 80
//         border.color: "#6E6E6E" // Subtle border for better definition
//         border.width: 2

//     }

//     ListView {
//         id: roomLobbyList
//         model: gameManager.clientsInLobby
//         delegate: Item {
//             width: roomLobbyList.width
//             height: 60
//             Row {
//                 spacing: 10
//                 anchors.verticalCenter: parent.verticalCenter
//                 anchors.horizontalCenter: parent.horizontalCenter

//                 Text {
//                     id: userID
//                     text: "Player " + modelData
//                     font.pixelSize: 24
//                     color: "#FFFFFF"
//                     font.bold: true
//                 }

//                 Image {
//                     id: checkImage
//                     visible: gameManager.isClientReady(modelData)

//                     Connections {
//                         target: gameManager
//                         function onReadyClientsListChanged() {
//                             checkImage.visible = gameManager.isClientReady(modelData);
//                         }
//                     }

//                     source: "assets:/check.png"
//                     width: 30
//                     height: 30
//                     fillMode: Image.PreserveAspectFit
//                 }
//             }
//         }
//         anchors.fill: roomLobbyListBackground
//     }

//     Rectangle {
//         id: messageWindowBackground
//         radius: 10
//         color: "#4B4B4B"
//         anchors {
//             left: parent.left
//             top: roomLobbyListBackground.bottom
//             right: parent.right
//             topMargin: 20
//             leftMargin: 20
//             rightMargin: 20
//             bottomMargin: 20
//         }
//         border.color: "#6E6E6E"
//         border.width: 2
//         height: parent.height / 2
//     }

//     TextEdit {
//         id: messageWindow
//         anchors.fill: messageWindowBackground
//         font.pixelSize: 20
//         color: "#E0E0E0"
//         readOnly: true
//         padding: 10
//     }

//     Connections {
//         target: gameManager
//         function onNewLobbyMessage(message) { messageWindow.append(message) }
//     }

//     GameButton {
//         id: readyButton
//         buttonText: "Ready"
//         buttonTextPixelSize: 28

//         height: 50
//         anchors {
//             top: sendTextButton.bottom
//             left: parent.left
//             right: parent.right
//             topMargin: 20
//             leftMargin: 20
//             rightMargin: 20
//             bottomMargin: 20
//         }
//         onButtonClicked: gameManager.readyToPlay()
//     }

//     GameButton {
//         id: sendTextButton
//         buttonText: "Send"
//         buttonTextPixelSize: 28
//         width: 120
//         height: 50
//         anchors {
//             top: messageWindowBackground.bottom

//            right: messageWindowBackground.right

//             topMargin: 20
//         }
//         onButtonClicked: {
//             gameManager.sendMessageToLobby(sendTextInput.text)
//             sendTextInput.text = ""
//         }
//     }

//     Rectangle {
//         id: sendTextFieldBackground
//         radius: 10
//         color: "#4B4B4B"
//         anchors {
//             top: sendTextButton.top
//             bottom: sendTextButton.bottom
//             left: messageWindowBackground.left
//             right: sendTextButton.left
//             rightMargin: 20
//         }
//         border.color: "#6E6E6E"
//         border.width: 2
//     }

//     TextInput {
//         id: sendTextInput
//         anchors.fill: sendTextFieldBackground
//         anchors.margins: 10
//         font.pixelSize: 28
//         color: "#000000"
//         clip: true
//         onAccepted: {
//             gameManager.sendMessageToLobby(sendTextInput.text)
//             sendTextInput.text = ""
//         }
//     }
// }
