import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15
import sudoku 1.0

Item {
    property int difficultyLevel: 1
    property bool gridInitializedBool: false
    property var initialGrid: null
    property var selectedCell: null
    property int elapsedTime: 0
    property int emptyCells: 0
    property int invalidCells: 0
    property string gridStr: "000000000000000000000000000000000000000000000000000000000000000000000000000000000"

    property int clientRemaining: 0
    property int oppRemaining: 0

    property string clientIDString: "0000"

    property int selectedNum: 0

    signal gameLoss()
    signal quitClicked()
    signal backClicked()
    signal pauseClicked()
    signal setGridString(string str)
    signal updateRemaining(int numRemaining)
    signal gameWon()
    signal goToLobby()
    signal goHome()
    signal quitGame()
    signal cancelQuit()
    signal opponentQuit()

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        function getDifficultyText(level) {
            switch (level) {
                case 1: return "Easy";
                case 2: return "Medium";
                case 3: return "Hard";
                default: return "Unknown";
            }
        }

        GridLayout {
            id: mainLayout
            rows: 4
            columns: 2
            anchors.fill: parent

            Rectangle {
                Layout.row: 0
                Layout.column: 0
                Layout.fillWidth: true
                Layout.preferredWidth: mainLayout.width * 0.5
                Layout.preferredHeight: mainLayout.height * 0.08
                color: "#2f3136"

                Text {
                    text: "Difficulty: " + getDifficultyText(difficultyLevel) + " - ClientID: " + clientIDString;
                    font.pixelSize: 16
                    color: "white"

                    anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 10
                        rightMargin: 10
                        bottomMargin: 10
                        topMargin: 0
                    }
                }
            }

            Rectangle {
                Layout.row: 0
                Layout.column: 1
                Layout.fillWidth: true // Fill the width of the cell
                Layout.preferredWidth: mainLayout.width * 0.5
                Layout.preferredHeight: mainLayout.height * 0.08
                color: "#2f3136"

                RowLayout {
                    anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        margins: 10
                    }

                    GameButton {
                        id: settingsBtn
                        buttonText: "Settings"
                        buttonTextPixelSize: 16
                        buttonBold: false
                        buttonWidth: 90
                        buttonHeight: 40
                        onButtonClicked: settingsClicked()
                        visible: false
                    }

                    GameButton {
                        id: quickBtn
                        buttonText: "Quit"
                        buttonTextPixelSize: 16
                        buttonBold: false
                        buttonWidth: 90
                        buttonHeight: 40
                        onButtonClicked: quitClicked()
                    }
                }
            }

            Rectangle {
                Layout.row: 1
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.04
                color: "#2f3136"

                RowLayout {
                    anchors {
                        bottom: parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }

                    Text {
                        id: timeDisplay
                        font.pointSize: 12
                        color: "white"
                        font.family: "Roboto"
                        text: {
                            var minutes = Math.floor(elapsedTime / 60)
                            var seconds = elapsedTime % 60
                            return minutes + ":" + (seconds < 10 ? "0" + seconds : seconds) + "\t"
                        }
                    }

                    GameButton {
                        id: pauseBtn
                        buttonText: "| |"
                        buttonTextPixelSize: 16
                        buttonBold: true
                        buttonWidth: 40
                        buttonHeight: 30
                        onButtonClicked: pauseClicked()
                    }

                }

            }

            Rectangle {
                Layout.row: 2
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.05
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
                        text: "YOU : " + clientRemaining + "\t\t";
                    }

                    Text {
                        id: oppRemainingText
                        font.pointSize: 12
                        color: "white"
                        text: "OPP : " + oppRemaining;
                    }
                }

            }

            Rectangle {
                Layout.row: 3
                Layout.column: 0
                Layout.columnSpan: 2
                Layout.fillWidth: true
                Layout.preferredHeight: mainLayout.height * 0.6
                color: "#2f3136"

                Grid {
                    id: sudokuGrid
                    anchors {
                        horizontalCenter: parent.horizontalCenter
                        verticalCenter: parent.verticalCenter
                        margins: 5
                    }

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
                                    "predefinedNumber": 0
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
                color: "#2f3136"

                RowLayout {
                    spacing: 5
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


    onSetGridString: {
        gridStr = newStr;
    }

    function updateGridString(newStr) {
        gridStr = newStr;
        sudokuHelperModel.parseString(gridStr);
        numEmptyCells();
        console.log("sudokuHelperModel.parseString(gridStr);");
    }

    function updateOppRemaining(sender, rem) {
        console.log("updateOppRemaining : ", sender, " ", rem);
        if (sender !== clientIDString) {
            oppRemaining = parseInt(rem);
        }
    }

    function handleCellClicked(index) {
        var row = Math.floor(index / 9);
        var col = index % 9;
        selectedCell = sudokuGrid.sudokuCells[row][col];
        selectedNum = selectedCell.predefinedNumber;
        console.log("Selected cell index = ", index);
    }

    // Connect to the Sudoku C++ class
    Connections {
        target: sudokuHelperModel
        function onPuzzleLoaded() {
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
        }


        clientRemaining = emptyCells
        updateRemaining(emptyCells);
        console.log("remaining: ", emptyCells);
    }

    function highlightCells(index) {
        var row = Math.floor(index / 9);
        var col = index % 9;

        for (var i = 0; i < 9; ++i) {
            sudokuGrid.sudokuCells[row][i].highlighted = true;
            sudokuGrid.sudokuCells[i][col].highlighted = true;
        }

        var startRow = Math.floor(row / 3) * 3;
        var startCol = Math.floor(col / 3) * 3;
        for (var j = startRow; j < startRow + 3; ++j) {
            for (var k = startCol; k < startCol + 3; ++k) {
                sudokuGrid.sudokuCells[j][k].highlighted = true;
            }
        }


        for (var a = 0; a < 9; ++a) {
            for (var b = 0; b < 9; ++b) {
                if (sudokuGrid.sudokuCells[a][b].predefinedNumber === selectedNum
                        && selectedNum !== 0) {
                    sudokuGrid.sudokuCells[a][b].selected = true;
                }
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
        }
        onNewGameClicked: {
            visible: false;
            close()
            goToLobby()
        }
    }

    onGameLoss: {
        gameTimer.running = false
        sudokuLossPopup.difficultyText = getDifficultyText();
        sudokuLossPopup.visible = true
    }

    onQuitClicked: {
        sudokuQuitPopup.difficultyText = getDifficultyText();
        sudokuQuitPopup.visible = true
    }

    SudokuQuitPopup {
        id: sudokuQuitPopup
        anchors.centerIn: parent
        modal:true

        onOkClicked: {
            visible: false
            close()
            quitGame()
        }

        onCancelClicked: {
            visible: false;
            close()
        }
    }

    onOpponentQuit: {
        sudokuOpponentQuitPopup.difficultyText = getDifficultyText();
        gameTimer.running = false
        sudokuOpponentQuitPopup.visible = true
    }

    SudokuOpponentQuitPopup {
        id: sudokuOpponentQuitPopup
        anchors.centerIn: parent
        modal: true

        onOkClicked: {
            gameTimer.running = false
            visible: false
            close()
            quitGame()
        }
    }

}
