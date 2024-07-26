
#include "clientgamemanager.h"
#include <QDebug>

ClientGameManager::ClientGameManager(QObject *parent)
    : QObject{parent}, m_clientID(QString()), m_clientsInLobby(QStringList()), m_roomLobbyCode(QString()), m_readyClientsList(QStringList())
{
    m_messageProcessor = new ClientMessageProcessor(this);
    connect(m_messageProcessor, &ClientMessageProcessor::uniqueIDRegistration, this, &ClientGameManager::registerUniqueID);
    connect(m_messageProcessor, &ClientMessageProcessor::newLobby, this, &ClientGameManager::lobbyJoined);
    connect(m_messageProcessor, &ClientMessageProcessor::lobbyListUpdated, this, &ClientGameManager::setClientsInLobby);

    // forward signal
    connect(m_messageProcessor, &ClientMessageProcessor::newLobbyMessage, this, &ClientGameManager::newLobbyMessage);
    connect(m_messageProcessor, &ClientMessageProcessor::readyListChanged, this, &ClientGameManager::newClientReadyList);
    connect(m_messageProcessor, &ClientMessageProcessor::gameStarting, this, &ClientGameManager::gameStarting);
    connect(m_messageProcessor, &ClientMessageProcessor::updateOpponentRemaining, this, &ClientGameManager::updateOpponentRemaining);
    connect(m_messageProcessor, &ClientMessageProcessor::opponentGameWon, this, &ClientGameManager::opponentGameWonRequest);
}

ClientGameManager::~ClientGameManager() {
    m_messageProcessor->deleteLater();
}

QString ClientGameManager::roomLobbyCode() {
    return m_roomLobbyCode;
}

QString ClientGameManager::getClientID() {
    qDebug() << "------ get m_clientID = " << m_clientID;
    return m_clientID;
}

QStringList ClientGameManager::clientsInLobby() {
    return m_clientsInLobby;
}

QStringList ClientGameManager::readyClientsList() {
    return m_readyClientsList;
}

void ClientGameManager::setRoomLobbyCode(QString lobbyCode) {
    if (m_roomLobbyCode != lobbyCode) {
        m_roomLobbyCode = lobbyCode;
        emit roomLobbyCodeChanged();
    }
}

void ClientGameManager::setClientsInLobby(QStringList clients) {
    if (m_clientsInLobby != clients) {
        m_clientsInLobby = clients;
        emit clientsInLobbyChanged();
    }
}

void ClientGameManager::processSocketMessage(QString message) {
    m_messageProcessor->processMessage(message);
}


void ClientGameManager::createGameRequest() {
    QString message = "type:createGame;payload:0;sender:" + m_clientID;
    // QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
    emit newMessageReadyToSend(message);
}

void ClientGameManager::joinLobbyRequest(QString lobbyID) {
    QString message = "type:joinGame;payload:" + lobbyID + ";sender:" + m_clientID;
    // QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
    emit newMessageReadyToSend(message);
}

void ClientGameManager::sendMessageToLobby(QString message) {
    QString fullMessage = "type:message;payload:" + message + ";lobbyID:" + m_roomLobbyCode + ";sender:" + m_clientID;
    // QString sizePrefix = QString::number(fullMessage.size()).rightJustified(4, '0');
    emit newMessageReadyToSend(fullMessage);
}

void ClientGameManager::readyToPlay() {
    QString message = "type:readyToPlay;payload:1;sender:" + m_clientID;
    // QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
    emit newMessageReadyToSend(message);
}

bool ClientGameManager::isClientReady(QString clientID) {
    return m_readyClientsList.contains(clientID);
}

void ClientGameManager::registerUniqueID(QString uniqueID) {
    m_clientID = uniqueID;
    qDebug() << "Client App: New client ID is " << m_clientID;
}

void ClientGameManager::lobbyJoined(QString lobbyID, QStringList clients) {
    setRoomLobbyCode(lobbyID);
    setClientsInLobby(clients);
    qDebug() << "emit inGameLobby();";
    emit inGameLobby();
}

void ClientGameManager::newClientReadyList(QStringList readyClients) {
    if (m_readyClientsList != readyClients) {
        m_readyClientsList = readyClients;
        emit readyClientsListChanged();
    }
}

void ClientGameManager::updateRemaining(int numRemaining) {
    QString message = "type:updateRemaining;payload:" + QString::number(numRemaining) + ";lobbyID:" + m_roomLobbyCode + ";sender:" + m_clientID;
    emit newMessageReadyToSend(message);
}

void ClientGameManager::clientGameWon() {
    QString message = "type:clientGameWon;payload:0;lobbyID:" + m_roomLobbyCode + ";sender:" + m_clientID;
    m_readyClientsList = QStringList();
    emit newMessageReadyToSend(message);
}

void ClientGameManager::opponentGameWonRequest(QString senderID) {
    if (senderID != m_clientID){
        m_readyClientsList = QStringList();
        emit opponentGameWon();
    }
}



