#ifndef CLIENTMESSAGEPROCESSOR_H
#define CLIENTMESSAGEPROCESSOR_H

#include <QObject>

class ClientMessageProcessor : public QObject
{
    Q_OBJECT
public:
    explicit ClientMessageProcessor(QObject *parent = nullptr);
    void processMessage(QString message);

signals:
    void uniqueIDRegistration(QString uniqueID);
    void newLobby(QString lobbyID, QStringList clients);
    void lobbyListUpdated(QStringList clients);
    void newLobbyMessage(QString message);
    void readyListChanged(QStringList readyList);
    void gameStarting(QString gridtString);
};

#endif // CLIENTMESSAGEPROCESSOR_H
