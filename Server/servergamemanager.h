#ifndef SERVERGAMEMANAGER_H
#define SERVERGAMEMANAGER_H

#include <QObject>
#include "servertcphandler.h"
#include "servermessageprocessor.h"
#include "servergamelobbyhandler.h"
#include "../Utils/includes/sudokuhelper.h"

class ServerGameManager : public QObject {
    Q_OBJECT
public:
    explicit ServerGameManager(QObject *parent = nullptr);
    ~ServerGameManager();

public slots:
    void createGameLobbyRequest(QString uniqueID);
    void joinGameLobbyRequest(QString lobbyID, QString uniqueID);
    void messageLobbyRequest(QString message, QString lobbyID, QString senderID);
    void userReadyListChanged();
    void userReadyToPlay(QString uniqueID);
    void gameReadyToBegin();
    void updateRemainingRequest(QString message, QString lobbyID, QString senderID);
    void clientGameWonRequest(QString lobbyID, QString senderID);

signals:


private:
    ServerTcpHandler * m_socketHandler;
    ServerMessageProcessor * m_messageProcessor;
    QMap<QString, ServerGameLobbyHandler*> m_gameLobbyMap;
    QString generateUniqueLobbyID();
    SudokuHelper m_sudokuHelper;
};

#endif // SERVERGAMEMANAGER_H
