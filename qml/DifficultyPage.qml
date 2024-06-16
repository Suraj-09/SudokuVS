import QtQuick 2.15
import QtQuick.Controls 2.15
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
                margins: 20 // Margin from parent edges
            }
            spacing: 20

            Text {
                text: "Select Difficulty"
                font.pixelSize: 32 // Adjust font size as needed
                color: "white"
                Layout.alignment: Qt.AlignHCenter // Center the text horizontally
            }

            ColumnLayout {
                spacing: 20
                Layout.alignment: Qt.AlignHCenter // Center the ColumnLayout horizontally

                Button {
                    text: "Easy"
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                    onClicked: selectDifficulty(1)
                }

                Button {
                    text: "Medium"
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                    onClicked: difficultySelected(2)
                }

                Button {
                    text: "Hard"
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                    onClicked: difficultySelected(3)
                }

                Button {
                    text: "Back"
                    onClicked: backClicked()
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                }
            }
        }
    }

    function selectDifficulty(difficulty) {
        difficultySelected(difficulty);
    }
}
