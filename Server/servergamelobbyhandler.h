#ifndef SERVERGAMELOBBYHANDLER_H
#define SERVERGAMELOBBYHANDLER_H

#include <QObject>
#include <QMap>
#include <QDebug>

class ServerGameLobbyHandler : public QObject {
    Q_OBJECT
public:
    explicit ServerGameLobbyHandler(QString lobbyID, QObject *parent);
    void addClient(QString clientID);
    QString clientsInLobby();
    QStringList clientsInLobbyList();

    void userReadyToPlay(QString clientID);
    void resetReadyToPlay();
    QString whoIsReady();

    void setDifficulty(int difficulty);
    int getDifficulty();

signals:
    void userReadyListChanged();
    void gameReadyToBegin();

private:
    QString m_lobbyID;
    int m_difficulty;
    QList<QString> m_gameClientList;
    QMap<QString, bool> m_clientReadyList;
};

#endif // SERVERGAMELOBBYHANDLER_H
