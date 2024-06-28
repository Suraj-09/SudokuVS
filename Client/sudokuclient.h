#ifndef SUDOKUCLIENT_H
#define SUDOKUCLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QDebug>

class SudokuClient : public QObject {
    Q_OBJECT

public:
    explicit SudokuClient(QObject *parent = nullptr);
    void connectToServer(const QString &host, quint16 port);
    void sendReady();
    void sendRemainingCells(int remaining);
    void sendFinished();

private slots:
    void readServerData();
    void handleDisconnected();

private:
    QTcpSocket *tcpSocket;
};

#endif // SUDOKUCLIENT_H
