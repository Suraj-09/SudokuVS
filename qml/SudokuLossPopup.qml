// SudokuPopup.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    width: 200
    height: 120
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        border.width: 1
        color: "#2f3136"
        radius: 5
    }

    ColumnLayout {
        Layout.fillWidth: true
        anchors.centerIn: parent
        spacing: 10
         anchors.horizontalCenter: parent.horizontalCenter
        Text {
            text: "Game Over"
            font.pixelSize: 20
            color: "white"
        }
        Text {
            text: "Difficulty: " + difficultyText
            font.pixelSize: 16
            color: "white"
        }

        RowLayout {
            spacing: 20

            Button {
                text: "Home"
                onClicked: {
                    homeClicked()
                }
            }
            Button {
                text: "New Game"
                onClicked: {
                    newGameClicked()
                }
            }
        }
    }

    signal homeClicked()
    signal newGameClicked()

    property string difficultyText: ""
    // property string timeTakenText: ""
}
