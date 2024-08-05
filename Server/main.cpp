#include <QCoreApplication>
#include "servergamemanager.h"

int main(int argc, char *argv[])
{
    QCoreApplication a(argc, argv);

    ServerGameManager ServerGameManager;

    return a.exec();
}
