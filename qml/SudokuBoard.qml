import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Item {
    property int difficultyLevel: 1 // Initialize with a default value

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        // Difficulty text on the top left
        Text {
            text: {
                switch (difficultyLevel) {
                    case 1: return "Difficulty: Easy";
                    case 2: return "Difficulty: Medium";
                    case 3: return "Difficulty: Hard";
                    default: return "Difficulty: Unknown";
                }
            }
            font.pixelSize: 16 // Adjust font size as needed
            color: "white"
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 20
        }

        // Back button on the top right
        Button {
            text: "Back"
            onClicked: backClicked()
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
        }

        ColumnLayout {
            anchors {
                fill: parent
                topMargin: 60 // Adjust top margin to leave space for the header
                leftMargin: 20
                rightMargin: 20
                bottomMargin: 20
            }
            spacing: 16

            Grid {
                id: sudokuGrid
                columns: 9
                spacing: 2
                Layout.alignment: Qt.AlignHCenter // Center the grid horizontally

                // Define a 2D array to hold references to SudokuTextField objects
                property var sudokuCells: []

                Component.onCompleted: {
                    var predefinedNumbers = [
                        [5, 3, 0, 0, 7, 0, 0, 0, 0],
                        [6, 0, 0, 1, 9, 5, 0, 0, 0],
                        [0, 9, 8, 0, 0, 0, 0, 6, 0],
                        [8, 0, 0, 0, 6, 0, 0, 0, 3],
                        [4, 0, 0, 8, 0, 3, 0, 0, 1],
                        [7, 0, 0, 0, 2, 0, 0, 0, 6],
                        [0, 6, 0, 0, 0, 0, 2, 8, 0],
                        [0, 0, 0, 4, 1, 9, 0, 0, 5],
                        [0, 0, 0, 0, 8, 0, 0, 7, 9]
                    ];

                    for (var i = 0; i < 9; ++i) {
                        var row = [];
                        for (var j = 0; j < 9; ++j) {
                            var sudokuTextField = Qt.createComponent("qrc:/qt/qml/SudokuVS/qml/SudokuTextField.qml").createObject(sudokuGrid, {
                                "index": i * 9 + j,
                                "predefinedNumber": predefinedNumbers[i][j]
                            });
                            row.push(sudokuTextField);
                        }
                        sudokuCells.push(row);
                    }
                }
            }
        }
    }

    signal backClicked()
}
