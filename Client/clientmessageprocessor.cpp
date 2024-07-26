#include "clientmessageprocessor.h"
#include <QDebug>
#include <QRegularExpression>


ClientMessageProcessor::ClientMessageProcessor(QObject *parent)
    : QObject{parent} {}

void ClientMessageProcessor::processMessage(QString message) {
    qDebug() << "Client App: Message to process: " << message;
    //type:uinqueID;payload:5555

    // type:uniqueID;payload:5555
    // type:newLobbyCreated;payload:1111;clientList:1234,4444,5555
    // type:joinSuccess;payload:1111;clientList:1234,4444,5555
    // type:updatedClientList;payload:" + existingLobby->clientsInLobby(), existingLobby->clientsInLobbyList());
    // type:lobbyMessage;payload:message;sender:1234
    // type:readyListChanged;payload:" + existingLobby->whoIsReady()
    // type:gameReadyToBegin;payload:0

    QRegularExpression re(";");
    QRegularExpression re2(",");
    QStringList separated = message.split(re);

    if (separated.first() == "type:uniqueID") {
        // create game

        qDebug() << "Client App: unique ID registration";
        separated.pop_front();
        if (separated.first().contains("payload:")) {
            QString newClientID = separated.first().remove("payload:");
            emit uniqueIDRegistration(newClientID);
        }


    } else if (separated.first() == "type:newLobbyCreated" || separated.first() == "type:joinSuccess") {
        qDebug() << "Client App: Client joined lobby!";

        separated.pop_front();
        QString newLobbyID = QString();
        QStringList lobbyClients = QStringList();
        if (separated.first().contains("payload:")) {
            newLobbyID = separated.first().remove("payload:");
            // emit newLobby(newLobbyID);
        }

        separated.pop_front();
        if (separated.first().contains("clientList:")) {
            QString clients = separated.first();
            clients = clients.remove("clientList:");
            lobbyClients = clients.split(re2);
        }

        qDebug() << "Clients App: Clients in lobby: " << lobbyClients;

        if (newLobbyID != QString() && lobbyClients != QStringList()) {
            emit newLobby(newLobbyID, lobbyClients);
        }

    } else if (separated.first() == "type:joinError") {

    } else if (separated.first() == "type:updatedClientList") {
        qDebug() << "Client App: Received updated client list";


        separated.pop_front();
        QStringList lobbyClients = QStringList();

        if (separated.first().contains("payload:")) {
            QString clients = separated.first().remove("payload:");
            lobbyClients = clients.split(re2);
        }


        if (lobbyClients != QStringList()) {
            emit lobbyListUpdated(lobbyClients);
        }

    } else if (separated.first() == "type:lobbyMessage") {
        // senderID: message
        QString newMessage;
        QString senderID;

        separated.pop_front();
        if (separated.front().contains("payload:")) {
            newMessage = separated.front().remove("payload:");
        }
        separated.pop_front();
        if (separated.front().contains("sender:")) {
            senderID = separated.front().remove("sender:");
        }

        QString displayMessage(senderID + ": " + newMessage);
        emit newLobbyMessage(displayMessage);

    } else if (separated.front() == "type:readyListChanged") {
        separated.pop_front();
        QString payload = separated.front().remove("payload:");
        QStringList readyClients = payload.split(re2);
        emit readyListChanged(readyClients);
    } else if (separated.first() == "type:gameReadyToBegin") {
        qDebug() << "readyToBegin";
        // type:gameReadyToBegin;payload:0
        QString gridString;
        separated.pop_front();
        if (separated.front().contains("payload:")) {
            gridString = separated.front().remove("payload:");
        }

        qDebug() << "gridString " << gridString;

        emit gameStarting(gridString);
    } else if (separated.first() == "type:updateRemaining") {
        qDebug() << "updateRemaining";

        QString newMessage;
        QString senderID;

        separated.pop_front();
        if (separated.front().contains("payload:")) {
            newMessage = separated.front().remove("payload:");
        }
        separated.pop_front();
        if (separated.front().contains("sender:")) {
            senderID = separated.front().remove("sender:");
        }

        QString displayMessage(senderID + "," + newMessage);
        qDebug() << "remaining: (sender: " + senderID + ") : " + displayMessage;
        emit updateOpponentRemaining(senderID, newMessage);
    } else if (separated.first() == "type:clientGameWon") {
        // qDebug() << "updateRemaining";

        QString newMessage;
        QString senderID;

        separated.pop_front();
        if (separated.front().contains("payload:")) {
            newMessage = separated.front().remove("payload:");
        }
        separated.pop_front();
        if (separated.front().contains("sender:")) {
            senderID = separated.front().remove("sender:");
        }

        // QString displayMessage(senderID + "," + newMessage);
        // qDebug() << "remaining: (sender: " + senderID + ") : " + displayMessage;
        emit opponentGameWon(senderID);

    }



}














