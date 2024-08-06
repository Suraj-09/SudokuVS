#ifndef SERVERTCPHANDLER_H
#define SERVERTCPHANDLER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QMap>

class ServerTcpHandler : public QObject {
    Q_OBJECT

public:
    explicit ServerTcpHandler(QObject *parent = nullptr);
    ~ServerTcpHandler();

signals:
    void newMessageToProcess(const QString &message);

public slots:
    void sendTextMessageToClient(const QString &message, const QString &clientID);
    void sendTextMessageToMultipleClients(const QString &message, const QStringList &clientIDs);

private slots:
    void onNewConnection();
    void onReadyRead();
    void onSocketDisconnected();

private:
    QTcpServer *m_socketServer;
    QMap<QString, QTcpSocket*> m_clientList;
    QString generateUniqueClientID();
    static QByteArray buffer;
};

#endif // SERVERTCPHANDLER_H
