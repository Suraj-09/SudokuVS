
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "../Utils/includes/sudokuhelper.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SudokuHelper>("sudoku", 1, 0, "SudokuHelper");


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
