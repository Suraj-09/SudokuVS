#include "sudokuserver.h"
#include <QDebug>

SudokuServer::SudokuServer(QObject *parent) : QObject(parent), readyClients(0) {
    tcpServer = new QTcpServer(this);
    connect(tcpServer, &QTcpServer::newConnection, this, &SudokuServer::newConnection);
}

void SudokuServer::startServer() {
    if (!tcpServer->listen(QHostAddress::Any, 12345)) {
        qCritical() << "Unable to start the server:" << tcpServer->errorString();
        return;
    }
    qDebug() << "Server started, waiting for clients to connect...";
    qDebug() << "Server is running on IP:" << tcpServer->serverAddress().toString() << "Port:" << tcpServer->serverPort();
}

void SudokuServer::newConnection() {
    QTcpSocket *clientSocket = tcpServer->nextPendingConnection();
    clients << clientSocket;

    connect(clientSocket, &QTcpSocket::readyRead, this, &SudokuServer::readClientData);
    connect(clientSocket, &QTcpSocket::disconnected, this, &SudokuServer::handleClientDisconnected);

    qDebug() << "Client connected:" << clientSocket->peerAddress().toString();

    if (clients.size() == 1) {
        // First client, provide the game code
        clientSocket->write("GAME_CODE:1234\n");
    } else if (clients.size() == 2) {
        // Second client, notify both clients to get ready
        for (QTcpSocket *client : clients) {
            client->write("WAITING_FOR_READY\n");
        }
    }
}

void SudokuServer::readClientData() {
    QTcpSocket *clientSocket = qobject_cast<QTcpSocket *>(sender());
    QString data = QString::fromUtf8(clientSocket->readAll());

    if (data.startsWith("READY")) {
        readyClients++;
        if (readyClients == 2) {
            // Both clients are ready, send the Sudoku string
            sudokuString = "SUDOKU_STRING:..."; // Generate or fetch the Sudoku string
            for (QTcpSocket *client : clients) {
                client->write("START_GAME:" + sudokuString.toUtf8() + "\n");
            }
        }
    } else if (data.startsWith("REMAINING:")) {
        // Process remaining cells info
        for (QTcpSocket *client : clients) {
            client->write(data.toUtf8() + "\n");
        }
    } else if (data.startsWith("FINISHED")) {
        // Determine the winner and notify both clients
        for (QTcpSocket *client : clients) {
            if (client == clientSocket) {
                client->write("WINNER\n");
            } else {
                client->write("LOSER\n");
            }
        }
    }
}

void SudokuServer::handleClientDisconnected() {
    QTcpSocket *clientSocket = qobject_cast<QTcpSocket *>(sender());
    clients.removeAll(clientSocket);
    clientSocket->deleteLater();
    qDebug() << "Client disconnected:" << clientSocket->peerAddress().toString();
}
