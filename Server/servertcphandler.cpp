#include "servertcphandler.h"
#include <QRandomGenerator>
#include <QDebug>

ServerTcpHandler::ServerTcpHandler(QObject *parent)
    : QObject(parent)
{
    m_socketServer = new QTcpServer(this);
    connect(m_socketServer, &QTcpServer::newConnection, this, &ServerTcpHandler::onNewConnection);

    if (m_socketServer->listen(QHostAddress::Any, 8080)) {
        qDebug() << "Server is running!";
        qDebug() << m_socketServer->serverAddress() << " : " << m_socketServer->serverPort();
    } else {
        qDebug() << "Server unable to start listening for connections!";
    }
}

ServerTcpHandler::~ServerTcpHandler() {
    m_socketServer->close();
    qDeleteAll(m_clientList);
    m_clientList.clear();
}

void ServerTcpHandler::onNewConnection() {
    qDebug() << "New client connected!";
    QString newClientID = generateUniqueClientID();

    QTcpSocket *nextClient = m_socketServer->nextPendingConnection();
    nextClient->setParent(this);

    connect(nextClient, &QTcpSocket::readyRead, this, &ServerTcpHandler::onReadyRead);
    connect(nextClient, &QTcpSocket::disconnected, this, &ServerTcpHandler::onSocketDisconnected);

    m_clientList[newClientID] = nextClient;

    qDebug() << "New Client ID: " << newClientID;

    QString message = "type:uniqueID;payload:" + newClientID;
    sendTextMessageToClient(message, newClientID);
}

void ServerTcpHandler::sendTextMessageToClient(const QString &message, const QString &clientID) {
    if (m_clientList.contains(clientID)) {
        QTcpSocket *existingClient = m_clientList[clientID];
        qDebug() << "Server App: sending message: " << message.toUtf8();

        QString sizePrefix = QString::number(message.size()).rightJustified(4, '0');
        QString completeMessage = sizePrefix + message;

        existingClient->write(completeMessage.toUtf8());
    }
}

void ServerTcpHandler::sendTextMessageToMultipleClients(const QString &message, const QStringList &clientIDs) {
    for (const QString &clientID : clientIDs) {
        sendTextMessageToClient(message, clientID);
    }
}

void ServerTcpHandler::onReadyRead() {
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    // static QByteArray buffer;
    buffer.append(client->readAll());
    // qDebug() << "Server processing: " << buffer;

    const QByteArray prefix = "sudokuvsclient";

    while (true) {
        int prefixIndex = buffer.indexOf(prefix);

        if (prefixIndex == -1) {
            return; // No prefix found, exit the loop
        }

        // Remove the part of the buffer before and including the prefix
        buffer.remove(0, prefixIndex + prefix.size());

        // Check if there's enough data left for the size prefix
        if (buffer.size() < 4) {
            return; // Not enough data for the size prefix, exit the loop
        }

        bool flag;
        int messageSize = buffer.left(4).toInt(&flag);

        if (!flag) {
            qDebug() << "Invalid size prefix";
            break;
            // buffer.clear(); // Clear the buffer to avoid further issues
            // return;
        }

        // Ensure there's enough data for the full message
        if (buffer.size() < 4 + messageSize) {
            // Not enough data for the full message, exit the loop
            return;
        }

        QByteArray message = buffer.mid(4, messageSize);
        buffer.remove(0, 4 + messageSize);

        qDebug() << "Server received: " << message;
        emit newMessageToProcess(message);
    }
}


void ServerTcpHandler::onSocketDisconnected() {
    QTcpSocket *client = qobject_cast<QTcpSocket*>(sender());
    if (!client) return;

    for (auto it = m_clientList.begin(); it != m_clientList.end(); ++it) {
        if (it.value() == client) {
            QString clientID = it.key();
            m_clientList.remove(clientID);
            client->deleteLater();
            break;
        }
    }
}

QString ServerTcpHandler::generateUniqueClientID() {
    QString newClientID;
    do {
        newClientID = QString::number(QRandomGenerator::global()->bounded(1000, 10000));
    } while (m_clientList.contains(newClientID));
    return newClientID;
}
