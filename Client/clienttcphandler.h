#ifndef CLIENTTCPHANDLER_H
#define CLIENTTCPHANDLER_H

#include <QObject>
#include <QTcpSocket>

class ClientTcpHandler : public QObject {
    Q_OBJECT

public:
    explicit ClientTcpHandler(QObject *parent = nullptr);
    ~ClientTcpHandler();

    void connectToServer(const QString &hostAddress, quint16 port);
    void sendMessageServer(const QString &message);

signals:
    void newMessageToProcess(const QString &message);

private slots:
    void onConnected();
    void onReadyRead();
    void onDisconnected();

private:
    QTcpSocket *m_tcpSocket;
};

#endif // CLIENTTCPHANDLER_H
