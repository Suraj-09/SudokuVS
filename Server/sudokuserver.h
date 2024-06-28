#ifndef SUDOKUSERVER_H
#define SUDOKUSERVER_H

#include <QObject>
#include <QTcpServer>
#include <QTcpSocket>
#include <QList>

class SudokuServer : public QObject {
    Q_OBJECT

public:
    explicit SudokuServer(QObject *parent = nullptr);
    void startServer();

private slots:
     void newConnection();
     void readClientData();
     void handleClientDisconnected();

private:
    QTcpServer *tcpServer;
    QList<QTcpSocket *> clients;
    QString sudokuString;
    int readyClients;
};

#endif // SUDOKUSERVER_H
