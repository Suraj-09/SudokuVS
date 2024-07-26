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
    property int emptyCells: 0
    property int invalidCells: 0
    // property int mistakes: 0
    property string gridStr: "000000000000000000000000000000000000000000000000000000000000000000000000000000000"

    property int clientRemaining: 0
    property int oppRemaining: 0

    property string clientIDString: "0000"

    signal gameLoss()

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        GridLayout {
            id: mainLayout
            rows: 4
            columns: 2
            anchors.fill: parent // Fill the parent item

            // Top Left: Difficulty Text
            Rectangle {
                Layout.row: 0
                Layout.column: 0
                Layout.fillWidth: true
                Layout.preferredWidth: mainLayout.width * 0.5
                Layout.preferredHeight: mainLayout.height * 0.08
                // color: "#373737" // Set background color for visualization
                color: "#2f3136"

                Text {
                    text: {
                        switch (difficultyLevel) {
                            case 1: return "Difficulty: Easy" + " - ClientID: " + clientIDString;
                            case 2: return "Difficulty: Medium"  + " - ClientID: " + clientIDString;
                            case 3: return "Difficulty: Hard"  + " - ClientID: " + clientIDString;
                            default: return "Difficulty: Unknown"  + " - ClientID: " + clientIDString;
                        }

                    }
                    font.pixelSize: 16
                    color: "white"

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        // margins: 10
                        leftMargin: 10
                        rightMargin: 10
                        bottomMargin: 10
                        topMargin: 0
                    }

                }

            }

            // Top Right: Settings and Back Buttons
            Rectangle {
                Layout.row: 0
                Layout.column: 1
                Layout.fillWidth: true // Fill the width of the cell
                Layout.preferredWidth: mainLayout.width * 0.5
                Layout.preferredHeight: mainLayout.height * 0.08
                // color: "lightgreen"
                color: "#2f3136"

                RowLayout {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }

                    Button {
                        id: settingsBtn
                        text: "Settings"
                        onClicked: settingsClicked()
                    }

                    Button {
                        id: backBtn
                        text: "Back"
                        onClicked: backClicked()
                    }
                }
            }

            Rectangle {
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.07
                // color: "darkblue"
                color: "#2f3136"

                RowLayout {
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                    // Text {
                    //     id: mistakesLabel
                    //     font.pointSize: 12
                    //     color: "white"
                    //     text: "Mistakes: " + mistakes + "/3\t"
                    // }

                    Text {
                        id: timeDisplay
                        font.pointSize: 12
                        color: "white"
                        text: {
                            var minutes = Math.floor(elapsedTime / 60)
                            var seconds = elapsedTime % 60
                            return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds) + "\t"
                        }
                    }

                    Button {
                        id: pauseBtn
                        text: "| |"
                        Layout.preferredWidth: 25
                        onClicked: pauseClicked()
                    }

                }

            }

            Rectangle {
                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.07
                // color: "darkblue"
                color: "#2f3136"

                RowLayout {
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: clientRemainingText
                        font.pointSize: 12
                        color: "white"
                        text: "YOU : " + clientRemaining + "\t";
                    }

                    Text {
                        id: oppRemainingText
                        font.pointSize: 12
                        color: "white"
                        text: "OPP : " + oppRemaining;
                    }
                }

            }


            // Sudoku Grid
            Rectangle {
                Layout.row: 3
                Layout.column: 0
                Layout.columnSpan: 2 // Span across two columns
                Layout.fillWidth: true // Fill the width of the cell
                Layout.preferredHeight: mainLayout.height * 0.65
                // color: "lightcoral" // Set background color for visualization
                color: "#2f3136"

                Grid {

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                        margins: 5
                    }

                    id: sudokuGrid

                    // anchors.fill: parent // Fill the parent rectangle
                    columns: 9
                    spacing: 0

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
                        numEmptyCells();
                    }
                }
            }

            Rectangle {
                Layout.row: 4
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.2
                // color: "lightskyblue"
                color: "#2f3136"

                RowLayout {
                    spacing: 5 // Adjust spacing between items

                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        top: parent.top
                        margins: 5
                    }

                    Repeater {
                        model: 9

                        SudokuNumButton {
                            text: (index + 1).toString()
                            onClicked: {
                                if (selectedCell !== null && !selectedCell.readOnly) {
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
    signal pauseClicked()
    signal setGridString(string str)
    signal updateRemaining(int numRemaining)
    signal gameWon()
    signal goToLobby()
    signal goHome()

    onSetGridString: {
        gridStr = newStr;
    }

    function setBoard() {

    }

    // Example function to emit the signal
    function updateGridString(newStr) {
        // setGridString(newStr);

        // console.log("gridStr = newStr", newStr, newStr.size());
        gridStr = newStr;
        sudokuHelperModel.parseString(gridStr);
        numEmptyCells();
        console.log("sudokuHelperModel.parseString(gridStr);");
    }

    function updateOppRemaining(sender, rem) {
        if (sender !== clientIDString) {
            oppRemaining = parseInt(rem);
        }
    }

    Component.onCompleted: {
        // sudokuHelperModel.loadFromFile("res/sudoku2.txt");
        // sudokuHelperModel.loadFromDatabase(difficultyLevel);
        // sudokuHelperModel.parseString(gridStr);
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
            var grid = sudokuHelperModel.getGrid();
        }
    }


    function updateGrid(grid) {
        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                cell.predefinedNumber = grid[i][j];
            }
        }
    }

    function onNumberChanged(index, newNumber) {
        var row = Math.floor(index / 9);
        var col = index % 9;
        var oldValue = sudokuHelperModel.getCellValue(row, col);


        var isValid = sudokuHelperModel.setCellValue(row, col, newNumber);
        var cell = sudokuGrid.sudokuCells[row][col];
        var wasValid = cell.valid;

        if ((oldValue === 0 || !wasValid) && newNumber !== 0 && isValid) {
            emptyCells--;
        } else if (oldValue !== 0 && newNumber === 0 && wasValid) {
             emptyCells++;
        }

        if (isValid) {
            cell.valid = true;

            if (wasValid === true) {
                invalidCells--;
            }

            checkIfGridIsFilled();
        } else {
            cell.valid = false;
            invalidCells++;
            // mistakes++;

            // if (mistakes >= 3) {
            //     gameLoss();
            // }

        }


        clientRemaining = emptyCells
        updateRemaining(emptyCells);
        console.log("remaining: ", emptyCells);
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

    function checkIfGridIsFilled() {
        var allFilled = true;

        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                if (cell.text.length === 0 || cell.invalid) {
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
            gameWon()
            showGameWonPopup();
        }
    }

    function numEmptyCells() {
        var empty = 0;

        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                if (cell.text.length === 0) {
                    empty++;
                }
            }
        }

        emptyCells = empty;
        clientRemaining = emptyCells
        updateRemaining(emptyCells);
        console.log("remaining: ", emptyCells);
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
    SudokuWinPopup {
        id: popup
        anchors.centerIn: parent
        modal:true

        onHomeClicked: {
            visible: false
            close()
            goHome()
            // stackView.pop();
            // stackView.pop();
        }
        onNewGameClicked: {
            visible: false;
            close()
            goToLobby()
            // stackView.pop();
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

    function hideGrid(boolVal) {
        for (var i = 0; i < 9; ++i) {
            for (var j = 0; j < 9; ++j) {
                var cell = sudokuGrid.sudokuCells[i][j];
                cell.hidden = boolVal;
            }
        }
    }

    onPauseClicked: {
        hideGrid(true);
        sudokuPausePopup.visible = true;
        gameTimer.running = false
    }

    SudokuPausePopup {
        id: sudokuPausePopup
        anchors.centerIn: parent
        modal:true

        onResumeClicked: {
            hideGrid(false)
            visible: false
            close()
            gameTimer.running = true
        }
    }

    SudokuLossPopup {
        id: sudokuLossPopup
        anchors.centerIn: parent
        modal:true

        onHomeClicked: {
            visible: false
            close()
            goHome()
            // stackView.pop();
            // stackView.pop();
        }
        onNewGameClicked: {
            visible: false;
            close()
            goToLobby()
            // stackView.pop();
        }
    }

    onGameLoss: {
        gameTimer.running = false
        sudokuLossPopup.difficultyText = getDifficultyText();
        sudokuLossPopup.visible = true
    }

}
