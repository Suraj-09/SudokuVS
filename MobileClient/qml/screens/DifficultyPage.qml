import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15
import "qrc:/qml/components"

Item {
    signal backClicked(bool isMultiplayer)
    signal difficultySelected(int difficulty, bool isMultiplayer)

    property bool isMultiplayer: false // default to solo mode

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
                text: "Select Difficulty"
                font.pixelSize: Math.min(Screen.width, Screen.height) * 0.1
                font.bold: true
                font.family: "Roboto"
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                spacing: 30
                Layout.alignment: Qt.AlignHCenter

                GameButton {
                    buttonText: "Easy"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonBold: true
                    buttonTextPixelSize: 20
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: selectDifficulty(1, isMultiplayer)
                }

                GameButton {
                    buttonText: "Medium"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonBold: true
                    buttonTextPixelSize: 20
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: difficultySelected(2, isMultiplayer)
                }

                GameButton {
                    buttonText: "Hard"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonBold: true
                    buttonTextPixelSize: 20
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: difficultySelected(3, isMultiplayer)
                }

                GameButton {
                    buttonText: "Back"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonBold: true
                    buttonTextPixelSize: 20
                    Layout.alignment: Qt.AlignHCenter
                    onButtonClicked: backClicked(isMultiplayer)
                }
            }
        }
    }

    function selectDifficulty(difficulty, isMultiplayer) {
        difficultySelected(difficulty, isMultiplayer);
    }

    function setMultiplayer() {
        isMultiplayer = true;
    }
}
