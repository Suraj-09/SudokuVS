
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "clienttcphandler.h"
#include "clientgamemanager.h"
#include "../Utils/includes/sudokuhelper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    ClientTcpHandler socketHandler;
    socketHandler.connectToServer("127.0.0.1", 8080);  // Change this to connect to the TCP server
    // socketHandler.connectToServer("20.42.87.120", 8080);  // Change this to connect to the TCP server

    ClientGameManager gameManager;
    QObject::connect(&socketHandler, &ClientTcpHandler::newMessageToProcess, &gameManager, &ClientGameManager::processSocketMessage);
    QObject::connect(&gameManager, &ClientGameManager::newMessageReadyToSend, &socketHandler, &ClientTcpHandler::sendMessageServer);


    QQmlApplicationEngine engine;

    qmlRegisterType<SudokuHelper>("sudoku", 1, 0, "SudokuHelper");
    engine.rootContext()->setContextProperty("socketHandler", &socketHandler);  // Update context property name if necessary
    engine.rootContext()->setContextProperty("gameManager", &gameManager);


    // Connect signal for handling errors during object creation
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    // Load the main QML file from the resources
    // engine.load(QUrl(QStringLiteral("qrc:/Main.qml")));
    engine.loadFromModule("SudokuVS", "Main");

    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
