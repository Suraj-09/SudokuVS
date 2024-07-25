#include "servergamelobbyhandler.h"

ServerGameLobbyHandler::ServerGameLobbyHandler(QString lobbyID, QObject *parent)
    : QObject{parent}, m_lobbyID(lobbyID) {
    m_clientReadyList.clear();

}

void ServerGameLobbyHandler::addClient(QString clientID) {
    if (!m_gameClientList.contains(clientID)) {
        m_gameClientList.append(clientID);
    }

    m_clientReadyList.clear();
    foreach(const QString& client, m_gameClientList) {
        m_clientReadyList[client] = false;
    }

    emit userReadyListChanged();

}

QString ServerGameLobbyHandler::clientsInLobby() {
    QString ret;
    foreach (const QString& client, m_gameClientList) {
        ret.append(client + ",");
    }

    ret.chop(1);

    return ret;
}

QStringList ServerGameLobbyHandler::clientsInLobbyList() {
    return m_gameClientList;
}

void ServerGameLobbyHandler::userReadyToPlay(QString clientID) {
    if (m_gameClientList.contains(clientID)) {
        m_clientReadyList[clientID] = true;
        emit userReadyListChanged();

        bool notReady = false;

        foreach(const QString& clientID, m_clientReadyList.keys()) {
            if (!m_clientReadyList[clientID]) {
                notReady = true;
            }
        }

        qDebug() << "notReady: " << notReady;
        if (!notReady && m_clientReadyList.size() >= 2) {
            emit gameReadyToBegin();
        }
    }
}

QString ServerGameLobbyHandler::whoIsReady() {
    QString returnValue;
    QStringList clientsInReadyList = m_clientReadyList.keys();
    for (int idx = 0; idx < clientsInReadyList.size(); idx++) {
        QString clientID = clientsInReadyList[idx];
        if (m_clientReadyList[clientID]) {
            returnValue.append(clientID + ",");
        }
    }

    if (returnValue != QString())
        returnValue.chop(1);

    return returnValue;
}
