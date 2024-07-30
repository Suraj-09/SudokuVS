import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15

Item {
    signal backClicked()
    signal createGame()
    signal joinGame()

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 20

            Text {
                text: "SudokuVS"
                font.pixelSize: 64
                font.bold: true
                font.family: "Roboto"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }


            ColumnLayout {
                spacing: 30
                Layout.alignment: Qt.AlignHCenter

                GameButton {
                    buttonText: "Create Game"
                    buttonWidth: 180
                    buttonHeight: 50
                    buttonTextPixelSize: 24
                    buttonBold: true
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: createGame()
                }

                GameButton {
                    buttonText: "Join Game"
                    buttonWidth: 180
                    buttonHeight: 50
                    buttonTextPixelSize: 24
                    buttonBold: true
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: joinGame()
                }

                GameButton {
                    buttonText: "Back"
                    buttonWidth: 180
                    buttonHeight: 50
                    buttonTextPixelSize: 24
                    buttonBold: true
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: backClicked()
                }
            }

        }
    }
}
