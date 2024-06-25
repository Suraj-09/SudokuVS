import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15 // Import the Fusion style
import QtQuick.Layouts 1.15
import sudoku 1.0

Item {
    property int difficultyLevel: 1 // Initialize with a default value
    property bool gridInitializedBool: false // Flag to check if grid is initialized
    property var initialGrid: null // To store initial grid temporarily
    property var selectedCell: null

    property int elapsedTime: 0  // Time in seconds


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

        // Buttons on the top right
        RowLayout {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.margins: 20
            spacing: 20

            Button {
                text: "Settings"
                onClicked: settingsClicked()
            }

            Button {
                text: "Back"
                onClicked: backClicked()
            }
        }

        ColumnLayout {
            anchors {
                fill: parent
                topMargin: 20
                leftMargin: 10
                rightMargin: 10
                bottomMargin: 20
            }
            spacing: 10

            RowLayout {
                id: infoRow

                Layout.alignment: Qt.AlignHCenter
                anchors.bottom: sudokuGrid.top

                Text {
                    id: timeDisplay
                    font.pointSize: 16
                    color: "white"
                    text: {
                        var minutes = Math.floor(elapsedTime / 60)
                        var seconds = elapsedTime % 60
                        return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds)

                    }
                }


            }

            Grid {
                id: sudokuGrid
                columns: 9
                spacing: 0
                Layout.alignment: Qt.AlignHCenter // Center the grid horizontally
                bottomPadding: 10
                topPadding: 10


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

                            sudokuTextField.cellClicked.connect(handleCellClicked)
                            sudokuTextField.numberChanged.connect(onNumberChanged);

                            sudokuTextField.leftBorder   = (j % 3 === 0) ? 3 : 1;
                            sudokuTextField.topBorder    = (i % 3 === 0) ? 3 : 1;
                            sudokuTextField.rightBorder  = (j === 8)     ? 3 : 1;
                            sudokuTextField.bottomBorder = (i === 8)     ? 3 : 1;

                            row.push(sudokuTextField);
                        }

                        sudokuCells.push(row);
                    }

                    gridInitializedBool = true;

                    if (initialGrid !== null) {
                        updateGrid(initialGrid);
                        initialGrid = null;
                    }

                    selectedCell = sudokuCells[0][0];
                }
            }

            RowLayout {
                id: numberInputRow
                spacing: 3
                Layout.alignment: Qt.AlignHCenter
                anchors.top: sudokuGrid.bottom

                Repeater {
                    model: 9

                    SudokuNumButton {
                        text: (index + 1).toString()
                        onClicked: {
                            if (selectedCell !== null) {
                                if (!selectedCell.readOnly) {
                                    selectedCell.text = (index + 1).toString();
                                    onNumberChanged(selectedCell.index, index + 1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    signal backClicked()

    // Load Sudoku puzzle initially
    Component.onCompleted: {
        sudokuHelperModel.loadFromFile("res/sudoku2.txt");
        console.log("Sudoku Board : Component.onCompleted");
    }

    function handleCellClicked(index) {
        var row = Math.floor(index / 9);
        var col = index % 9;
        selectedCell = sudokuGrid.sudokuCells[row][col];
        console.log("Selected cell index = ", index);
    }


    // Connect to the Sudoku C++ class
    Connections {
        target: sudokuHelperModel
        function onPuzzleLoaded() {
            // Handle puzzle loaded event
            console.log("Sudoku puzzle loaded!");

            var grid = sudokuHelperModel.getGrid();
            if (gridInitializedBool) {
                updateGrid(grid);
            } else {
                initialGrid = grid;
            }
        }

        function onGridUpdated() {
            // console.log("Grid updated from C++");
            var grid = sudokuHelperModel.getGrid();
            // updateGrid(grid);
        }

    }


    function updateGrid(grid) {
        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                cell.predefinedNumber = grid[i][j];

                // cell.isValid = sudokuHelperModel.isCellValid(i, j); // Update validity
            }
        }
    }

    function onNumberChanged(index, newNumber) {
        // console.log("index = ", index, " newNumber ", newNumber);
        var row = Math.floor(index / 9);
        var col = index % 9;
        var isValid = sudokuHelperModel.setCellValue(row, col, newNumber);
        var cell = sudokuGrid.sudokuCells[row][col];
        console.log("valid = ", isValid);
        // if isValid is false, set text field in red


        if (isValid) {
            console.log("checkIfGridIsFilled();");
            checkIfGridIsFilled(); // Check if the grid is filled after each number change
        }
    }

    // Highlighting functions
    function highlightCells(index) {
        var row = Math.floor(index / 9);
        var col = index % 9;

        // Highlight the row and column
        for (var i = 0; i < 9; ++i) {
            sudokuGrid.sudokuCells[row][i].highlighted = true;
            sudokuGrid.sudokuCells[i][col].highlighted = true;
        }

        // Highlight the 3x3 grid
        var startRow = Math.floor(row / 3) * 3;
        var startCol = Math.floor(col / 3) * 3;
        for (var j = startRow; j < startRow + 3; ++j) {
            for (var k = startCol; k < startCol + 3; ++k) {
                sudokuGrid.sudokuCells[j][k].highlighted = true;
            }
        }
    }

    function clearHighlights() {
        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                sudokuGrid.sudokuCells[i][j].highlighted = false;
                sudokuGrid.sudokuCells[i][j].selected = false;
            }
        }
    }
    // Within your Item component

    function checkIfGridIsFilled() {
        var allFilled = true;

        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                if (cell.text.length === 0) {
                    allFilled = false;
                    break;
                }
            }
            if (!allFilled) {
                break;
            }
        }

        if (allFilled) {
            console.log("All Sudoku cells are filled!");
            gameTimer.running = false;
            showGameWonPopup();

        }
    }


    // Define the C++ Sudoku model
    SudokuHelper {
        id: sudokuHelperModel
    }

    Timer {
            id: gameTimer
            interval: 1000
            repeat: true
            running: true
            onTriggered: {
                elapsedTime += 1
            }
        }

    // Popup component
    SudokuPopup {
        id: popup
        anchors.centerIn: parent
        modal:true

        onHomeClicked: {
            visible: false
            close()
            stackView.pop();
            stackView.pop();
        }
        onNewGameClicked: {
            visible: false;
            close()
            stackView.pop();
        }
    }

    function showGameWonPopup() {
        popup.difficultyText = getDifficultyText();
        popup.timeTakenText = getTimeTakenText();
        popup.visible = true;
    }

    function getDifficultyText() {
        switch (difficultyLevel) {
            case 1: return "Easy";
            case 2: return "Medium";
            case 3: return "Hard";
            default: return "Unknown";
        }
    }

    function getTimeTakenText() {
        var minutes = Math.floor(elapsedTime / 60);
        var seconds = elapsedTime % 60;
        return minutes + " min " + seconds + " sec";
    }
}
