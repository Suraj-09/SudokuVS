#include "sudokuhelper.h"
#include <QStandardPaths>
#include <QResource>


void printFilesInDirectory(const QString &directoryPath) {
    QDir dir(directoryPath);

    // Check if the directory exists
    if (!dir.exists()) {
        qWarning() << "Directory does not exist:" << directoryPath;
        return;
    }

    // List files and directories
    QStringList entries = dir.entryList(QDir::Files | QDir::Dirs | QDir::NoDotAndDotDot);

    qDebug() << "----------------------------------------------------------";
    qDebug() << "Files and directories in" << directoryPath << ":";

    foreach (const QString &entry, entries) {
        QFileInfo fileInfo(dir.absoluteFilePath(entry));

        if (fileInfo.isFile()) {
            qDebug() << "File:" << entry << "Size:" << fileInfo.size() << "bytes";
        } else if (fileInfo.isDir()) {
            qDebug() << "Directory:" << entry;
        }
    }

    qDebug() << "----------------------------------------------------------";
}

bool copyDatabaseIfNeeded(const QString &dbPath) {
    // if (QFile::exists(dbPath)) {
    //     return true; // Database already exists
    // }



    // // printFilesInDirectory("/");
    // // Access the database file in the assets folder
    // QResource dbResource("qrc:/sudoku.db");
    // // QResource dbResource("C:/code/qt/QtQuick/SudokuVS/MobileClient/build/Android_Qt_6_7_2_Clang_arm64_v8a-Debug/MobileClient/utils/databases");

    // if (dbResource.isValid()) {
    //     qint64 fileSize = dbResource.size();
    //     qDebug() << "Database file size in assets:" << fileSize << "bytes";
    // } else {
    //     qWarning() << "Failed to locate the database file in assets.";
    // }


    // Copy the database from the assets folder to internal storage
    // QFile assetDb(":/assets/sudoku.db"); // Replace with your actual assets path
    QFile assetDb(":/sudoku.db"); // Replace with your actual assets path
    // QFileInfo fileInfo
    if (assetDb.exists()) {
        if (assetDb.copy(dbPath)) {
            QFile::setPermissions(dbPath, QFileDevice::ReadOwner | QFileDevice::WriteOwner);
            return true;
        } else {
            qWarning() << "Failed to copy the database to internal storage.";
            return false;
        }
    } else {
        qWarning() << "Database not found in assets.";
        return false;
    }
}


SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent} {
    srand(static_cast<unsigned int>(time(nullptr)));

    QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + "/../plugins/sqldrivers");
    qDebug() << "QCoreApplication::applicationDirPath(): " << QCoreApplication::applicationDirPath();

    QStringList drivers = QSqlDatabase::drivers();
    qDebug() << "Available drivers:" << drivers;

    qDebug() << "----------------------------------------------------------";
    // // QString localStorage = QStandardPaths::writableLocation(QStandardPaths::GenericDataLocation);
    // QString localStorage = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    // if(QFile::copy("qrc:/sudoku.db", localStorage + "/test.db")) {
    //     qDebug() <<"File copied to " << localStorage << Qt::endl;
    // } else {
    //     qDebug() << "Not found 1" << Qt::endl;
    // }

    // if(QFile::copy("qrc:/assets/sudoku.db", localStorage + "/test2.db")) {
    //     qDebug() <<"File copied to " << localStorage << Qt::endl;
    // } else {
    //     qDebug() << "Not found 2" << Qt::endl;
    // }

    // if(QFile::copy("qrc:/qt/qml/MobileClient/utils/databases/sudoku.db", localStorage + "/test3.db")) {
    //     qDebug() <<"File copied to " << localStorage << Qt::endl;
    // } else {
    //     qDebug() << "Not found 3" << Qt::endl;
    // }

    qDebug() << "Checking resource path:" << QFile::exists(":/utils/databases/sudoku.db");
    qDebug() << "Checking resource path:" << QFile::exists(":/sudoku.db");
    qDebug() << "Checking resource path:" << QFile::exists(":/assets/sudoku.db");


    qDebug() << "----------------------------------------------------------";

    // qDebug() << QCoreApplication::applicationDirPath() + "/../../Utils/databases.db";
    // QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/sudoku.db";
    // qDebug() << dbPath;

    // QString dbPath = QCoreApplication::applicationDirPath() + "/MobileClient/utils/databases";
    // printFilesInDirectory("/data");
    // printFilesInDirectory("/data/app");
    // QString publicPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation) + "/sudoku.db";


    // QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
    // QString publicPath = QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation);

    // // qDebug() << "Database path:" << dbPath;
    // QString utilsPath = ":/utils/";
    // QString databasesPath = ":/utils/databases/";

    // qDebug() << "Database path:" << dbPath;

    // // Print files in the utils folder
    // printFilesInDirectory(utilsPath);

    // // Print files in the databases folder
    // printFilesInDirectory(databasesPath);

    // copyDatabaseToWritableLocation();

    // QString cpath = QDir::currentPath();
    // printFilesInDirectory(cpath);
    // printFilesInDirectory("/data");
    // printFilesInDirectory("/data/data");
    // printFilesInDirectory("/data/data");
    // printFilesInDirectory("/data/data/org.qtproject.example.appMobileClient");


    // /data/data/org.qtproject.example.appMobileClient/


    // // if (!QFile::exists(dbPath)) {
    //     // Attempt to copy the database from the resources
    //     if (QFile::copy(":/utils/databases/sudoku.db", dbPath)) {
    //         // Set permissions if the copy was successful
    //         if (!QFile::setPermissions(dbPath, QFile::WriteOwner | QFile::ReadOwner)) {
    //             qWarning() << "Failed to set permissions for" << dbPath;
    //         }
    //     } else {
    //         qWarning() << "Failed to copy database from resources!";
    //     }
    // // } else {
    //     // qDebug() << "Database already exists at" << dbPath;
    // QFile::copy(dbPath, publicPath);
    // // }


    // Determine the database path in internal storage
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/sudoku.db";
    // Ensure the directory exists
    QDir().mkpath(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));


    QFile assetDb(":/sudoku.db"); // Replace with your actual assets path
    // QFileInfo fileInfo
    if (assetDb.exists()) {
        if (QFile::exists(dbPath)) {
            QFile::remove(dbPath); // Remove any existing copy to avoid conflicts
        }
        if (assetDb.copy(dbPath)) {
            QFile::setPermissions(dbPath, QFileDevice::ReadOwner | QFileDevice::WriteOwner);
        } else {
            qWarning() << "Failed to copy the database to internal storage.";
        }
    } else {
        qWarning() << "Database not found in assets.";
    }


    m_database = QSqlDatabase::addDatabase("QSQLITE");

    m_database.setDatabaseName(dbPath);
    if (!m_database.open()) {
        qWarning() << "Failed to open the database:" << m_database.lastError().text();
        m_database.setDatabaseName(dbPath);
    }


    // QString dbPath = QCoreApplication::applicationDirPath() + "/../../utils/databases/sudoku.db";
    // qDebug() << "database path = " << dbPath;
    // // qDebug() << "Library Paths:" << QCoreApplication::libraryPaths();
    // // qDebug()  <<  QSqlDatabase::drivers();
    // m_database = QSqlDatabase::addDatabase("QSQLITE");

    // m_database.setDatabaseName(dbPath);

    // if (!m_database.open()) {
    //     qWarning() << "Could not open database:" << dbPath;
    // }

}

void SudokuHelper::openDatabase() {
    // QString dbPath = QCoreApplication::applicationDirPath() + "/../../utils/databases/sudoku.db";
    // QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/sudoku.db";
    QString dbPath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/sudoku.db";
    // m_database = QSqlDatabase::addDatabase("QSQLITE");
    // QString dbPath = ":utils/databases/sudoku.db";

    m_database.setDatabaseName(dbPath);

    if (!m_database.open()) {
        qWarning() << "Failed to open the database:" << m_database.lastError().text();
        return;
    }
}


QVector<QVector<int>> SudokuHelper::getGrid() const { return m_grid; }

bool SudokuHelper::loadFromDatabase(int difficulty) {

    if (!m_database.open()) {
        openDatabase();
    }

    if (m_database.open()) {
        qDebug() << "Database is open";
    } else {
        qDebug() << "Database is not open";
    }

    QStringList tables = m_database.tables();
    qDebug() << "Tables in database:";
    for (const QString &tableName : tables) {
        qDebug() << tableName;
    }

    // qDebug() << difficulty;
    QSqlQuery query(m_database);
    // query.prepare("SELECT grid FROM sudoku_grids WHERE difficulty = :difficulty ORDER BY RANDOM() LIMIT 1");
    // query.prepare("SELECT grid FROM sudoku_grids WHERE id = 1");
    // query.bindValue(":difficulty", difficulty);

    query.prepare("SELECT grid FROM sudoku_grids WHERE id = 1");

    if (!query.prepare("SELECT grid FROM sudoku_grids WHERE id = 1")) {
        qWarning() << "Failed to prepare query:" << query.lastError().text();
        return false;
    }

    qDebug() << "Query prepared:" << query.lastQuery();


    if (!query.exec()) {
        qWarning() << "Error retrieving grid:" << query.lastError().text();;
        m_database.close();
        return false;
    }

    if (query.next()) {
        QString gridString = query.value(0).toString();
        parseGridString(gridString);
        m_database.close();
        emit puzzleLoaded();
        return true;
    }

    m_database.close();
    return false;
}

QString SudokuHelper::loadStringFromDatabase(int difficulty) {

    if (!m_database.open()) {
        openDatabase();
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT grid FROM sudoku_grids WHERE difficulty = :difficulty ORDER BY RANDOM() LIMIT 1");
    query.bindValue(":difficulty", difficulty);

    if (!query.exec()) {
        qWarning() << "Error retrieving grid:" << query.lastError();
        m_database.close();
        return "";
    }

    if (query.next()) {
        QString gridString = query.value(0).toString();
        // parseGridString(gridString);
        m_database.close();
        // emit puzzleLoaded();
        return gridString;
    }

    m_database.close();
    return "";
}


void SudokuHelper::parseString(const QString &gridString) {

    parseGridString(gridString);
    emit puzzleLoaded();
}

void SudokuHelper::parseGridString(const QString &gridString) {
    m_grid.clear();

    for (int i = 0; i < 9; ++i) {
        QVector<int> rowValues;

        for (int j = 0; j < 9; ++j) {
            QChar ch = gridString.at(i * 9 + j);
            int num = ch.digitValue();
            rowValues.push_back(num);
        }

        m_grid.push_back(rowValues);
    }
}

bool SudokuHelper::loadFromFile(const QString &filePath) {
    QFile file(filePath);
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qWarning() << "Could not open file for reading:" << filePath;
        return false;
    }

    QTextStream in(&file);
    m_grid.clear();
    int row = 0;
    while (!in.atEnd() && row < 9) {
        QString line = in.readLine().trimmed();
        if (line.isEmpty()) continue;
        parseLine(line, row);
        ++row;
    }

    file.close();
    emit puzzleLoaded();
    return true;
}

void SudokuHelper::parseLine(const QString &line, int row) {
    QVector<int> rowValues;
    for (int col = 0; col < 9 && col < line.size(); ++col) {
        QChar ch = line.at(col);
        int num = ch.digitValue();  // Convert character to integer
        rowValues.push_back(num);
    }
    m_grid.push_back(rowValues);
}

int SudokuHelper::getCellValue(int row, int col) const {
    if (row < 0 || row >= 9 || col < 0 || col >= 9) return 0;

    return m_grid[row][col];
}

bool SudokuHelper::setCellValue(int row, int col, int value) {
    if (row < 0 || row >= 9 || col < 0 || col >= 9) return false;

    m_grid[row][col] = value;
    emit gridUpdated();

    return isCellValid(row, col);
}

bool SudokuHelper::isCellValid(int row, int col) const {
    int value = getCellValue(row, col);
    if (value == 0) return true;  // Empty cells are always valid

    // Check the row
    for (int c = 0; c < 9; ++c) {
        if (c != col && m_grid[row][c] == value) return false;
    }

    // Check the column
    for (int r = 0; r < 9; ++r) {
        if (r != row && m_grid[r][col] == value) return false;
    }

    // Check the 3x3 subgrid
    int startRow = (row / 3) * 3;
    int startCol = (col / 3) * 3;
    for (int r = startRow; r < startRow + 3; ++r) {
        for (int c = startCol; c < startCol + 3; ++c) {
            if ((r != row || c != col) && m_grid[r][c] == value) return false;
        }
    }

    return true;
}
