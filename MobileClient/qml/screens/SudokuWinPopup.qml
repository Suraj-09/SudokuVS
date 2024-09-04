// SudokuPopup.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/qml/components"


Popup {
    signal homeClicked()
    signal newGameClicked()
    signal lobbyClicked()
    signal quitClicked()

    property string difficultyText: ""
    property string timeTakenText: ""
    property bool multiplayerMode: false

    width: 200
    height: 150
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        border.width: 1
        color: "#2f3136"
        radius: 5
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 10
        Text {
            text: "Congratulations!"
            font.pixelSize: 20
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: "Difficulty: " + difficultyText
            font.pixelSize: 16
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        Text {
            text: "Time taken: " + timeTakenText
            font.pixelSize: 16
            color: "white"
            horizontalAlignment: Text.AlignHCenter
        }
        RowLayout {
            spacing: 20

            Button {
                text: multiplayerMode ? "Lobby" : "New Game"
                onClicked: {
                    multiplayerMode ? lobbyClicked() : newGameClicked()
                }
            }

            Button {
                text: multiplayerMode ? "Quit" : "Quit"
                onClicked: quitClicked()
            }
        }
    }
}
