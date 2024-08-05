#ifndef CLIENTGAMEMANAGER_H
#define CLIENTGAMEMANAGER_H

#include <QObject>
#include "clientmessageprocessor.h"

class ClientGameManager : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString roomLobbyCode READ roomLobbyCode WRITE setRoomLobbyCode NOTIFY roomLobbyCodeChanged FINAL)
    Q_PROPERTY(QStringList clientsInLobby READ clientsInLobby WRITE setClientsInLobby NOTIFY clientsInLobbyChanged FINAL)
public:
    explicit ClientGameManager(QObject *parent = nullptr);
    ~ClientGameManager();

    QString roomLobbyCode();
    QStringList clientsInLobby();
    QStringList readyClientsList();
    Q_INVOKABLE QString getClientID();

    Q_INVOKABLE void createGameRequest(int difficulty);
    Q_INVOKABLE void joinLobbyRequest(QString lobbyID);
    Q_INVOKABLE void sendMessageToLobby(QString message);
    Q_INVOKABLE bool isClientReady(QString clientID);
    Q_INVOKABLE void readyToPlay();
    Q_INVOKABLE void updateRemaining(int numRemaining);
    Q_INVOKABLE void clientGameWon();
    Q_INVOKABLE void clientQuit();

public slots:
    void setRoomLobbyCode(QString lobbyCode);
    void setClientsInLobby(QStringList clientList);

    // void setReadyClientsList(QStringList readyClientsList);

    void processSocketMessage(QString message);
    void registerUniqueID(QString uniqueID);
    void lobbyJoined(QString lobbyID, QStringList clients);
    void newClientReadyList(QStringList readyClients);
    void opponentGameWonRequest(QString senderID);
    void opponentQuitRequest(QString senderID);


signals:
    void roomLobbyCodeChanged();
    void clientsInLobbyChanged();
    void readyClientsListChanged();
    void newMessageReadyToSend(QString message);
    void inGameLobby();
    void newLobbyMessage(QString message);
    void gameStarting(QString message, int difficulty);
    void updateOpponentRemaining(QString sender, QString remaining);
    void opponentGameWon();
    void opponentQuit();

private:
    QString m_clientID;
    QStringList m_clientsInLobby;
    QString m_roomLobbyCode;
    QStringList m_readyClientsList;
    ClientMessageProcessor * m_messageProcessor;
};

#endif // CLIENTGAMEMANAGER_H
