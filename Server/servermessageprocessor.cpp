#include "servermessageprocessor.h"
#include <QDebug>
#include <QRegularExpression>


ServerMessageProcessor::ServerMessageProcessor(QObject *parent)
    : QObject{parent}
{}

void ServerMessageProcessor::processMessage(QString message) {
    qDebug() << "Server App: Message to process: " << message;
    //type:createGame;payload:0;sender:5555
    //type:joinGame;payload:4000;sender:5555
    //type:message;payload:HelloWorld;lobbyID:5999;sender:5555
    //type:updateRemaining;payload:25;lobbyID:5599;sender:5555

    QRegularExpression re;
    re.setPattern(";");
    QStringList separated = message.split(re);

    if (separated.first() == "type:createGame") {
        // create game
        qDebug() << "Create Game Request";
        separated.pop_front();
        separated.pop_front();

        if (separated.first().contains("sender:")) {
            QString senderID = separated.first().remove("sender:");
            emit createGameRequest(senderID);
        }

    } else if (separated.first() == "type:joinGame") {
        qDebug() << "Join Game Request";

        separated.pop_front();
        QString lobbyID = QString();
        QString senderID = QString();

        if (separated.first().contains("payload:")) {
            lobbyID = separated.first().remove("payload:");
        }

        separated.pop_front();

        if (separated.first().contains("sender:")) {
            senderID = separated.first().remove("sender:");
        }

        if ((lobbyID != QString()) && (lobbyID != QString())) {
            emit joinGameLobbyRequest(lobbyID, senderID);
        }

    } else if (separated.first() == "type:message") {
        //type:message;payload:HelloWorld;lobbyID:5999;sender:5555
        qDebug() << "Message Request";
        QString payload = QString();
        QString lobbyID = QString();
        QString senderID = QString();

        separated.pop_front();
        if (separated.first().contains("payload:")) {
            payload = separated.first().remove("payload:");
        }
        separated.pop_front();
        if (separated.first().contains("lobbyID:")) {
            lobbyID = separated.first().remove("lobbyID:");
        }
        separated.pop_front();
        if (separated.first().contains("sender:")) {
            senderID = separated.first().remove("sender:");
        }

        if (payload != QString() && lobbyID != QString() && senderID != QString()) {
            emit messageLobbyRequest(payload, lobbyID, senderID);
        }

    } else if (separated.front() == "type:readyToPlay") {
        qDebug() << "readyToPlay";
        // type:readyToPlay;payload:1;sender:5555
        if (separated.back().contains("sender:")) {
            QString clientID = separated.back().remove("sender:");
            emit clientReadyToPlay(clientID);
        }
    } else if (separated.first() == "type:updateRemaining") {
        QString payload = QString();
        QString lobbyID = QString();
        QString senderID = QString();

        separated.pop_front();
        if (separated.first().contains("payload:")) {
            payload = separated.first().remove("payload:");
        }
        separated.pop_front();
        if (separated.first().contains("lobbyID:")) {
            lobbyID = separated.first().remove("lobbyID:");
        }
        separated.pop_front();
        if (separated.first().contains("sender:")) {
            senderID = separated.first().remove("sender:");
        }

        if (payload != QString() && lobbyID != QString() && senderID != QString()) {
            emit updateRemainingRequest(payload, lobbyID, senderID);
        }
    } else if (separated.first() == "type:clientGameWon") {
        QString payload = QString();
        QString lobbyID = QString();
        QString senderID = QString();

        separated.pop_front();
        if (separated.first().contains("payload:")) {
            payload = separated.first().remove("payload:");
        }
        separated.pop_front();
        if (separated.first().contains("lobbyID:")) {
            lobbyID = separated.first().remove("lobbyID:");
        }
        separated.pop_front();
        if (separated.first().contains("sender:")) {
            senderID = separated.first().remove("sender:");
        }

        if (lobbyID != QString() && senderID != QString()) {
            emit clientGameWonRequest(lobbyID, senderID);
        }
    }

}
