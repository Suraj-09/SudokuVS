#include "sudokuclient.h"

SudokuClient::SudokuClient(QObject *parent) : QObject(parent) {
    tcpSocket = new QTcpSocket(this);

    connect(tcpSocket, &QTcpSocket::readyRead, this, &SudokuClient::readServerData);
    connect(tcpSocket, &QTcpSocket::disconnected, this, &SudokuClient::handleDisconnected);
}

void SudokuClient::connectToServer(const QString &host, quint16 port) {
    tcpSocket->connectToHost(host, port);
    if (!tcpSocket->waitForConnected(3000)) {
        qCritical() << "Error: " << tcpSocket->errorString();
    } else {
        qDebug() << "Connected to server!";
    }
}

void SudokuClient::sendReady() {
    tcpSocket->write("READY\n");
}

void SudokuClient::sendRemainingCells(int remaining) {
    tcpSocket->write(QString("REMAINING:%1\n").arg(remaining).toUtf8());
}

void SudokuClient::sendFinished() {
    tcpSocket->write("FINISHED\n");
}

void SudokuClient::readServerData() {
    while (tcpSocket->canReadLine()) {
        QString line = QString::fromUtf8(tcpSocket->readLine()).trimmed();
        qDebug() << "Received:" << line;

        if (line.startsWith("GAME_CODE:")) {
            QString gameCode = line.mid(QString("GAME_CODE:").length());
            qDebug() << "Game code received:" << gameCode;
            // Handle game code (e.g., display to user)
        } else if (line == "WAITING_FOR_READY") {
            qDebug() << "Server is waiting for readiness";
            // Update UI to show waiting status
        } else if (line.startsWith("START_GAME:")) {
            QString sudokuString = line.mid(QString("START_GAME:").length());
            qDebug() << "Sudoku game started with string:" << sudokuString;
            // Start the game with the received Sudoku string
        } else if (line.startsWith("REMAINING:")) {
            QString remainingInfo = line.mid(QString("REMAINING:").length());
            qDebug() << "Remaining cells info:" << remainingInfo;
            // Update the UI with the remaining cells info
        } else if (line == "WINNER") {
            qDebug() << "You are the winner!";
            // Show winning message
        } else if (line == "LOSER") {
            qDebug() << "You are the loser!";
            // Show losing message
        }
    }
}

void SudokuClient::handleDisconnected() {
    qDebug() << "Disconnected from server";
    // Handle disconnection (e.g., notify user, attempt to reconnect)
}
