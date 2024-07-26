#include "servergamemanager.h"

// #include <random>
#include <QRandomGenerator>
#include <QDebug>



ServerGameManager::ServerGameManager(QObject *parent) : QObject{parent} {
    m_socketHandler = new ServerTcpHandler(this);
    m_messageProcessor = new ServerMessageProcessor(this);
    // m_sudokuHelper = new SudokuHelper;
    connect(m_socketHandler, &ServerTcpHandler::newMessageToProcess, m_messageProcessor, &ServerMessageProcessor::processMessage);

    connect(m_messageProcessor, &ServerMessageProcessor::createGameRequest, this, &ServerGameManager::createGameLobbyRequest);
    connect(m_messageProcessor, &ServerMessageProcessor::joinGameLobbyRequest, this, &ServerGameManager::joinGameLobbyRequest);
    connect(m_messageProcessor, &ServerMessageProcessor::messageLobbyRequest, this, &ServerGameManager::messageLobbyRequest);
    connect(m_messageProcessor, &ServerMessageProcessor::clientReadyToPlay, this, &ServerGameManager::userReadyToPlay);
    connect(m_messageProcessor, &ServerMessageProcessor::updateRemainingRequest, this, &ServerGameManager::updateRemainingRequest);
    connect(m_messageProcessor, &ServerMessageProcessor::clientGameWonRequest, this, &ServerGameManager::clientGameWonRequest);

}

ServerGameManager::~ServerGameManager() {
    m_socketHandler->deleteLater();
}

void ServerGameManager::createGameLobbyRequest(QString uniqueID) {
    QString newLobbyID = generateUniqueLobbyID();

    ServerGameLobbyHandler *newGameLobby = new ServerGameLobbyHandler(newLobbyID, this);

    connect(newGameLobby, &ServerGameLobbyHandler::userReadyListChanged, this, &ServerGameManager::userReadyListChanged);
    connect(newGameLobby, &ServerGameLobbyHandler::gameReadyToBegin, this, &ServerGameManager::gameReadyToBegin);

    newGameLobby->addClient(uniqueID);
    m_gameLobbyMap[newLobbyID] = newGameLobby;
    qDebug() << "New game lobby ID: " << newLobbyID;

    QString message = "type:newLobbyCreated;payload:" + newLobbyID + ";clientList:" + newGameLobby->clientsInLobby();
    // QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
    m_socketHandler->sendTextMessageToClient(message, uniqueID);
}

QString ServerGameManager::generateUniqueLobbyID() {
    QString newLobbyID;
    do {
        newLobbyID = QString::number(QRandomGenerator::global()->bounded(1000, 10000));
    } while (m_gameLobbyMap.keys().contains(newLobbyID));
    return newLobbyID;
}


void ServerGameManager::joinGameLobbyRequest(QString lobbyID, QString uniqueID) {
    if (m_gameLobbyMap.contains(lobbyID)) {
        ServerGameLobbyHandler *existingLobby = m_gameLobbyMap[lobbyID];
        existingLobby->addClient(uniqueID);

        QString updateMessage = "type:updatedClientList;payload:" + existingLobby->clientsInLobby();
        // QString sizePrefixUpdate = QString::number(updateMessage.size()).rightJustified(4, '0');
        m_socketHandler->sendTextMessageToMultipleClients(updateMessage, existingLobby->clientsInLobbyList());

        QString joinSuccessMessage = "type:joinSuccess;payload:" + lobbyID + ";clientList:" + existingLobby->clientsInLobby();
        // QString sizePrefixJoinSuccess = QString::number(joinSuccessMessage.size()).rightJustified(4, '0');
        m_socketHandler->sendTextMessageToClient(joinSuccessMessage, uniqueID);
    } else {
        QString errorMessage = "type:joinError;payload:DNE";
        // QString sizePrefixError = QString::number(errorMessage.size()).rightJustified(4, '0');
        m_socketHandler->sendTextMessageToClient(errorMessage, uniqueID);
    }
}

void ServerGameManager::messageLobbyRequest(QString message, QString lobbyID, QString senderID) {
    if (m_gameLobbyMap.contains(lobbyID)) {
        ServerGameLobbyHandler *existingLobby = m_gameLobbyMap[lobbyID];
        QString lobbyMessage = "type:lobbyMessage;payload:" + message + ";sender:" + senderID;
        // QString sizePrefix = QString::number(lobbyMessage.size()).rightJustified(4, '0');
        m_socketHandler->sendTextMessageToMultipleClients(lobbyMessage, existingLobby->clientsInLobbyList());
    }
}

void ServerGameManager::userReadyListChanged() {
    ServerGameLobbyHandler *existingLobby = qobject_cast<ServerGameLobbyHandler *>(sender());
    QString readyListMessage = "type:readyListChanged;payload:" + existingLobby->whoIsReady();
    // QString sizePrefix = QString::number(readyListMessage.size()).rightJustified(4, '0');
    m_socketHandler->sendTextMessageToMultipleClients(readyListMessage, existingLobby->clientsInLobbyList());
}

void ServerGameManager::gameReadyToBegin() {
    ServerGameLobbyHandler *existingLobby = qobject_cast<ServerGameLobbyHandler *>(sender());
    QString gridString = m_sudokuHelper.loadStringFromDatabase(1);
    QString gameReadyMessage = "type:gameReadyToBegin;payload:" + gridString;
    qDebug() << "gridString = " << gridString;


    // QString sizePrefix = QString::number(gameReadyMessage.size()).rightJustified(4, '0');
    m_socketHandler->sendTextMessageToMultipleClients(gameReadyMessage, existingLobby->clientsInLobbyList());
}

void ServerGameManager::userReadyToPlay(QString uniqueID) {
    qDebug() << "User ready: " << uniqueID;
    QList<ServerGameLobbyHandler*> gameLobbyList = m_gameLobbyMap.values();

    foreach(ServerGameLobbyHandler* existingLobby, gameLobbyList) {
        existingLobby->userReadyToPlay(uniqueID);
    }
}

void ServerGameManager::updateRemainingRequest(QString message, QString lobbyID, QString senderID) {
    if (m_gameLobbyMap.contains(lobbyID)) {
        ServerGameLobbyHandler *existingLobby = m_gameLobbyMap[lobbyID];
        QString updateRemainingMessage = "type:updateRemaining;payload:" + message + ";sender:" + senderID;

        m_socketHandler->sendTextMessageToMultipleClients(updateRemainingMessage, existingLobby->clientsInLobbyList());
    }
}

void ServerGameManager::clientGameWonRequest(QString lobbyID, QString senderID) {
    if (m_gameLobbyMap.contains(lobbyID)) {
        ServerGameLobbyHandler *existingLobby = m_gameLobbyMap[lobbyID];
        existingLobby->resetReadyToPlay();
        QString clientGameWonMessage("type:clientGameWon;payload:0;sender:" + senderID);


        m_socketHandler->sendTextMessageToMultipleClients(clientGameWonMessage, existingLobby->clientsInLobbyList());
    }
}
