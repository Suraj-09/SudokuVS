#ifndef SERVERMESSAGEPROCESSORHANDLER_H
#define SERVERMESSAGEPROCESSORHANDLER_H

#include <QObject>

class ServerMessageProcessor : public QObject
{
    Q_OBJECT
public:
    explicit ServerMessageProcessor(QObject *parent = nullptr);

public slots:
    void processMessage(QString message);

signals:
    void createGameRequest(QString uniqueID);
    void joinGameLobbyRequest(QString lobbyID, QString uniqueID);
    void messageLobbyRequest(QString message, QString lobbyID, QString senderID);
    void clientReadyToPlay(QString uniqueID);
    void updateRemainingRequest(QString message, QString lobbyID, QString senderID);
    void clientGameWonRequest(QString lobbyID, QString senderID);
};

#endif // SERVERMESSAGEPROCESSORHANDLER_H
