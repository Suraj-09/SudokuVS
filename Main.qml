import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    visible: true
    width: 800
    height: 600
    title: "SudokuVS"

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: WelcomePage {
            onSoloSelected: {
                stackView.push(difficultyPage);
            }
        }

        Component {
            id: sudokuBoardPage
            SudokuBoard {
                // Ensure that backClicked signal is handled correctly in SudokuBoard.qml
                onBackClicked: stackView.pop();
            }
        }

        Component {
            id: difficultyPage
            DifficultyPage {
                onBackClicked: stackView.pop();
                onDifficultySelected: function(difficulty) {
                    stackView.push(sudokuBoardPage, {difficultyLevel: difficulty});
                }
            }
        }
    }
}
