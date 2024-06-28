#include <QCoreApplication>
#include "sudokuserver.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    SudokuServer server;
    server.startServer();

    return a.exec();
}
