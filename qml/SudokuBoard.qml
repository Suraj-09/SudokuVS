import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import sudoku 1.0

Item {
    property int difficultyLevel: 1 // Initialize with a default value
    property bool gridInitialized: false // Flag to check if grid is initialized
    property var initialGrid: null // To store initial grid temporarily

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
                    console.log("Creating Sudoku Grid");

                    for (var i = 0; i < 9; ++i) {
                        var row = [];
                        for (var j = 0; j < 9; ++j) {
                            var sudokuTextField = Qt.createComponent("qrc:/qt/qml/SudokuVS/qml/SudokuTextField.qml").createObject(sudokuGrid, {
                                "index": i * 9 + j,
                                "predefinedNumber": 0 // Initialize with 0, will be updated later
                            });
                            row.push(sudokuTextField);
                        }
                        sudokuCells.push(row);
                    }

                    gridInitialized = true;

                    if (initialGrid !== null) {
                        updateGrid(initialGrid);
                        initialGrid = null;
                    }
                }
            }
        }
    }

    signal backClicked()

    // Load Sudoku puzzle initially
    Component.onCompleted: {
        sudokuHelperModel.loadFromFile("res/sudoku1.txt");
        console.log("Sudoku Board : Component.onCompleted");
    }

    // Connect to the Sudoku C++ class
    Connections {
        target: sudokuHelperModel
        function onPuzzleLoaded() {
            // Handle puzzle loaded event
            console.log("Sudoku puzzle loaded!");

            var grid = sudokuHelperModel.getGrid();
            if (gridInitialized) {
                updateGrid(grid);
            } else {
                initialGrid = grid;
            }
        }
    }

    function updateGrid(grid) {
        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                sudokuGrid.sudokuCells[i][j].predefinedNumber = grid[i][j];
            }
        }
    }

    // Define the C++ Sudoku model
    SudokuHelper {
        id: sudokuHelperModel
    }
}
