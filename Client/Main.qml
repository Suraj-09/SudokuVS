import QtQuick 2.15
// import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// import QtQuick.Controls.Basic 2.15
import QtQuick.Controls.Fusion 2.15

import "qml"

ApplicationWindow {
    visible: true
    width: 1280
    height: 720
    title: "SudokuVS"

    Loader {
            id: mainLoader
            anchors.fill: parent
            sourceComponent: welcomePage
        }

        Component {
            id: welcomePage
            WelcomePage {
                onSoloSelected: {
                    mainLoader.sourceComponent = difficultyPage;
                }
                onVersusSelected: {
                    mainLoader.sourceComponent = versusOptionsPage;
                }
            }
        }

        Component {
            id: sudokuBoardPage
            SudokuBoard {
                // Ensure that backClicked signal is handled correctly in SudokuBoard.qml
                onBackClicked: mainLoader.sourceComponent = welcomePage;
            }
        }

        Component {
            id: difficultyPage
            DifficultyPage {
                property bool isMultiplayer: false
                onBackClicked: mainLoader.sourceComponent = welcomePage;
                onDifficultySelected: function(difficulty, isMultiplayer) {
                    console.log("isMultiplayer", isMultiplayer);
                    if (isMultiplayer) {
                        gameManager.createGameRequest();
                        console.log("gameManager.createGameRequest();")
                    } else {
                        mainLoader.sourceComponent = sudokuBoardPage;
                        mainLoader.item.difficultyLevel = difficulty;
                    }
                }
            }
        }

        Component {
            id: versusOptionsPage
            VersusOptionsPage {
                onBackClicked: mainLoader.sourceComponent = welcomePage;
                onCreateGame: {


                    mainLoader.sourceComponent = difficultyPage;

                    mainLoader.item.isMultiplayer = true;
                    mainLoader.item.set1();


                    // difficultyPage.isMultiplayer = true
                    // mainLoader.sourceComponent = difficultyPage;
                    // mainLoader.setSource("qrc:/qt/qml/SudokuVS/qml/DifficultyPage.qml",  {isMultiplayer: true})

                }

                onJoinGame: {
                    mainLoader.sourceComponent = joinLobbyScreen;
                }
            }
        }

        Component {
            id: lobbyScreen
            LobbyScreen {}
        }

        Component {
            id: joinLobbyScreen
            JoinLobbyScreen {
                onBackClicked: {
                    mainLoader.sourceComponent = versusOptionsPage;
                }

            }
        }

        Component {
            id: sudokuVSBoard
            SudokuVSBoard {
                onUpdateRemaining: function(numRemaining) {
                    gameManager.updateRemaining(numRemaining);
                }

                onGameWon: function() {
                    gameManager.clientGameWon()
                }

                onGoToLobby: function() {
                    mainLoader.sourceComponent = lobbyScreen;
                }

                onGoHome: function() {
                    mainLoader.sourceComponent = welcomePage;
                }
            }
        }

        Connections {
            target: gameManager
            function onInGameLobby() {
                mainLoader.sourceComponent = lobbyScreen;
            }

            function onGameStarting(gridString) {
                mainLoader.sourceComponent = sudokuVSBoard;
                if (mainLoader.item) {
                    mainLoader.item.updateGridString(gridString);
                    mainLoader.item.clientIDString = gameManager.getClientID();
                }
            }

            function onUpdateOpponentRemaining(sender, rem) {
                if (mainLoader.item && mainLoader.item.updateOppRemaining) {
                    mainLoader.item.updateOppRemaining(sender, rem);
                }
            }

            function onOpponentGameWon() {
                if (mainLoader.item) {
                    mainLoader.item.gameLoss();
                }
            }
        }

    // StackView {
    //     id: stackView
    //     anchors.fill: parent
    //     initialItem: WelcomePage {
    //         onSoloSelected: {
    //             stackView.push(difficultyPage);
    //         }
    //         onVersusSelected: {
    //             stackView.push(versusOptionsPage)
    //         }
    //     }

    //     Component {
    //         id: sudokuBoardPage
    //         SudokuBoard {
    //             // Ensure that backClicked signal is handled correctly in SudokuBoard.qml
    //             onBackClicked: stackView.pop();
    //         }
    //     }

    //     Component {
    //         id: difficultyPage
    //         DifficultyPage {
    //             onBackClicked: stackView.pop();
    //             onDifficultySelected: function(difficulty, isMultiplayer) {
    //                 console.log("isMultiplayer", isMultiplayer);
    //                 if (isMultiplayer) {
    //                     gameManager.createGameRequest()
    //                     // stackView.push(sudokuBoardPage, {difficultyLevel: difficulty});
    //                 } else {
    //                     stackView.push(sudokuBoardPage, {difficultyLevel: difficulty});
    //                 }
    //             }
    //         }
    //     }

    //     Component {
    //         id: versusOptionsPage
    //         VersusOptionsPage {
    //             onBackClicked: stackView.pop();
    //             onCreateGame: {
    //                 stackView.push(difficultyPage, {isMultiplayer: true});
    //             }
    //         }
    //     }

    //     Connections {
    //         target: gameManager
    //         function onInGameLobby() {
    //             // mainLoader.source = "ui/LobbyScreen.qml"
    //             stackView.push(lobbyScreen);
    //         }
    //     }

    //     Component {
    //         id: lobbyScreen
    //         LobbyScreen {}

    //     }

    // }
}
