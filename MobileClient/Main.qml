import QtQuick 2.15
// import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
// import QtQuick.Controls.Basic 2.15
import QtQuick.Controls.Fusion 2.15

import "qrc:/qml/components"

ApplicationWindow {
    visible: true
    width: Screen.width
    height: Screen.height
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
                    mainLoader.item.isMultiplayer = false;
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
                onBackClicked: function(isMultiplayer) {
                    if (isMultiplayer) {
                        mainLoader.sourceComponent = versusOptionsPage;
                    } else {
                        mainLoader.sourceComponent = welcomePage;
                    }
                }
                onDifficultySelected: function(difficulty, isMultiplayer) {
                    console.log("isMultiplayer", isMultiplayer);
                    if (isMultiplayer) {
                        gameManager.createGameRequest(difficulty);
                        console.log("gameManager.createGameRequest();")
                    } else {
                        mainLoader.sourceComponent = sudokuVSBoard;
                        console.log("mainLoader.sourceComponent ", mainLoader.sourceComponent)
                        if (mainLoader.item) {
                            mainLoader.item.updateGridString(gameManager.getGrid(difficulty));
                            mainLoader.item.difficultyLevel = difficulty
                            mainLoader.item.multiplayerMode = false
                            mainLoader.item.clientIDString = ""; //gameManager.getClientID();
                        }
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
                    mainLoader.item.setMultiplayer();
                }

                onJoinGame: {
                    mainLoader.sourceComponent = joinLobbyScreen;
                }
            }
        }

        Component {
            id: lobbyScreen
            LobbyScreen {
                onBackClicked: {
                    gameManager.clientQuit()
                    mainLoader.sourceComponent = versusOptionsPage;
                }
            }
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

                onGoToDifficultyPage: function() {
                    mainLoader.sourceComponent = difficultyPage;
                    mainLoader.item.isMultiplayer = false;
                }

                onGoHome: function() {
                    mainLoader.sourceComponent = welcomePage;
                }

                onQuitGame: function(multiplayerMode) {
                    if (multiplayerMode)
                        gameManager.clientQuit()

                    mainLoader.sourceComponent = welcomePage;
                }
            }
        }

        Connections {
            target: gameManager
            function onInGameLobby() {
                mainLoader.sourceComponent = lobbyScreen;
            }

            function onGameStarting(gridString, difficultyLevel) {
                mainLoader.sourceComponent = sudokuVSBoard;
                if (mainLoader.item) {
                    mainLoader.item.updateGridString(gridString);
                    mainLoader.item.difficultyLevel = difficultyLevel
                    mainLoader.item.multiplayerMode = true
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

            function onOpponentQuit() {
                if (mainLoader.sourceComponent === sudokuVSBoard) {
                    mainLoader.item.opponentQuit()
                }
            }

            function onClientsInLobbyChanged() {}
        }
}

