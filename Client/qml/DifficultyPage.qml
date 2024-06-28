import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15

Item {
    signal backClicked()
    signal difficultySelected(int difficulty)

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
                font.pixelSize: 32
                color: "white"
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                spacing: 20
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "Easy"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: selectDifficulty(1)
                }

                Button {
                    text: "Medium"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: difficultySelected(2)
                }

                Button {
                    text: "Hard"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: difficultySelected(3)
                }

                Button {
                    text: "Back"
                    onClicked: backClicked()
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }

    function selectDifficulty(difficulty) {
        difficultySelected(difficulty);
    }
}
