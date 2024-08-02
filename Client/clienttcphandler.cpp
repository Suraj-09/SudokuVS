#include "clienttcphandler.h"

ClientTcpHandler::ClientTcpHandler(QObject *parent) : QObject{parent} {
    m_tcpSocket = new QTcpSocket(this);

    connect(m_tcpSocket, &QTcpSocket::connected, this, &ClientTcpHandler::onConnected);
    connect(m_tcpSocket, &QTcpSocket::readyRead, this, &ClientTcpHandler::onReadyRead);
    connect(m_tcpSocket, &QTcpSocket::disconnected, this, &ClientTcpHandler::onDisconnected);
}

ClientTcpHandler::~ClientTcpHandler() {
    m_tcpSocket->close();
    m_tcpSocket->deleteLater();
}

void ClientTcpHandler::connectToServer(const QString &hostAddress, quint16 port) {
    qDebug() << "Client App: connect to server! " << hostAddress << ":" << port;
    m_tcpSocket->connectToHost(QHostAddress(hostAddress), port);
}

void ClientTcpHandler::sendMessageServer(const QString &message) {
    if (m_tcpSocket->state() == QAbstractSocket::ConnectedState) {
        QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
        QString completeMessage = "sudokuvsclient" + sizePrefix + message;

        m_tcpSocket->write(completeMessage.toUtf8());
    } else {
        qDebug() << "Client App: Not connected to server!";
    }
}

void ClientTcpHandler::onConnected() {
    qDebug() << "Client App: Connection established!";
}

void ClientTcpHandler::onReadyRead() {
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    static QByteArray buffer;
    buffer.append(client->readAll());
    qDebug() << "Client processing: " << buffer;

    while (buffer.size() > 4) {
        bool flag;
        int messageSize = buffer.left(4).toInt(&flag);

        if (!flag) {
            qDebug() << "Invalid size prefix";
            return;
        }

        if (buffer.size() < 4 + messageSize) {
            return; // incomplete message
        }

        QByteArray message = buffer.mid(4, messageSize);
        buffer.remove(0, 4 + messageSize);

        qDebug() << "Client received: " << message;
        emit newMessageToProcess(message);
    }
}

void ClientTcpHandler::onDisconnected() {
    qDebug() << "Client App: Disconnected from server!";
}
