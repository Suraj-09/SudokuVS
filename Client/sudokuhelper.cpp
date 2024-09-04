#include "sudokuhelper.h"
#include <QStandardPaths>
#include <QResource>


// SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent} {
//     srand(static_cast<unsigned int>(time(nullptr)));

//     qDebug() << "-- SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent}";

//     if (QSqlDatabase::contains("qt_sql_default_connection")) {
//         QSqlDatabase::removeDatabase("qt_sql_default_connection");
//     }
//     QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + "/../plugins/sqldrivers");

//     // qDebug() << QCoreApplication::applicationDirPath() + "/../../Utils/databases.db";

//     QString dbPath = QCoreApplication::applicationDirPath() + "/../../utils/databases/sudoku.db";
//     qDebug() << "database path = " << dbPath;
//     // qDebug() << "Library Paths:" << QCoreApplication::libraryPaths();
//     // qDebug()  <<  QSqlDatabase::drivers();


//     m_database = QSqlDatabase::addDatabase("QSQLITE");

//     if (QSqlDatabase::contains("qt_sql_default_connection")) {
//         QSqlDatabase::removeDatabase("qt_sql_default_connection");
//     }

//     dbPath = ":/utils/databases/sudoku.db";
//     QString path = ":/utils/databases/sudoku.db";
//     QFile file(path);
//     if (!file.exists()) {
//         qDebug() << "File not found:" << path;
//     } else {
//         qDebug() << "File found:" << path;
//     }

//     m_database.setDatabaseName(dbPath);


//     if (!m_database.open()) {
//         qWarning() << "Could not open database:" << dbPath;
//     }

// }

// void SudokuHelper::openDatabase() {
//     qDebug() << "-- void SudokuHelper::openDatabase()";
//     // QString dbPath = QCoreApplication::applicationDirPath() + "/../../utils/databases/sudoku.db";
//     // m_database = QSqlDatabase::addDatabase("QSQLITE");
//     QString dbPath = ":/utils/databases/sudoku.db";
//     m_database.setDatabaseName(dbPath);
// }

void setupDatabase() {
    // Path to the database in the Qt resource system
    QString resourcePath = ":/utils/databases/sudoku.db";

    // // Destination path in the application's writable location
    // QString writablePath = QStandardPaths::writableLocation(QStandardPaths::AppDataLocation) + "/sudoku.db";

    // // Create the directory if it doesn't exist
    // QDir dir(QStandardPaths::writableLocation(QStandardPaths::AppDataLocation));
    // if (!dir.exists()) {
    //     dir.mkpath(".");
    // }

    QString writablePath = QCoreApplication::applicationDirPath() + "/sudoku.db";

    // Check if the database already exists at the writable location
    if (!QFile::exists(writablePath)) {
        // Copy the file from the resource system to the writable location
        if (QFile::copy(resourcePath, writablePath)) {
            // Set the proper permissions
            QFile::setPermissions(writablePath, QFile::WriteOwner | QFile::ReadOwner);
        } else {
            qDebug() << "Failed to copy the database file to the writable location.";
            return;
        }
    }

    // Open the database from the writable location
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(writablePath);

    if (!db.open()) {
        qDebug() << "Could not open database:" << db.lastError().text();
    } else {
        qDebug() << "Database successfully opened from:" << writablePath;
    }
}

SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent} {
    srand(static_cast<unsigned int>(time(nullptr)));

    // qDebug() << "-- SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent}";

    // // Set the SQLite plugin path if needed
    // QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + "/../plugins/sqldrivers");

    // // Set the path to the embedded database resource
    // QString dbPath = ":/utils/databases/sudoku.db";

    // // Check if the resource file exists
    // QFile file(dbPath);
    // if (!file.exists()) {
    //     qDebug() << "File not found:" << dbPath;
    // } else {
    //     qDebug() << "File found:" << dbPath;
    // }

    // // Initialize the SQLite database connection
    // m_database = QSqlDatabase::addDatabase("QSQLITE");
    // m_database.setDatabaseName(dbPath);
    // m_database.open();

    // qDebug() << "1: " << m_database.lastError();


    // // Open the database connection
    // if (!m_database.open()) {
    //     qWarning() << "Could not open database:" << dbPath;
    //     qDebug() << "2: " << m_database.lastError();
    // }

    setupDatabase();
}

void SudokuHelper::openDatabase() {
    qDebug() << "-- void SudokuHelper::openDatabase()";

    // Open the database if not already opened
    if (!m_database.isOpen()) {
        if (!m_database.open()) {
            qWarning() << "Failed to open the database";
            m_database.open();
        }
    }
}


QVector<QVector<int>> SudokuHelper::getGrid() const { return m_grid; }

bool SudokuHelper::loadFromDatabase(int difficulty) {

    if (!m_database.open()) {
        openDatabase();
    }

    qDebug() << difficulty;
    QSqlQuery query(m_database);
    query.prepare("SELECT grid FROM sudoku_grids WHERE difficulty = :difficulty ORDER BY RANDOM() LIMIT 1");
    query.bindValue(":difficulty", difficulty);

    if (!query.exec()) {
        qWarning() << "Error retrieving grid:" << query.lastError();
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
    qDebug() << "-- QString SudokuHelper::loadStringFromDatabase(int difficulty)";

    QSqlQuery query(m_database);
    query.prepare("SELECT grid FROM sudoku_grids WHERE id = 51");

    // query.prepare("SELECT grid FROM sudoku_grids WHERE difficulty = :difficulty ORDER BY RANDOM() LIMIT 1");
    // query.bindValue(":difficulty", difficulty);

    if (!query.exec()) {
        qWarning() << "Error retrieving grid:" << query.lastError();
        m_database.close();
        return "";
    }

    if (query.next()) {
        QString gridString = query.value(0).toString();
        qDebug() << "gridString: " << gridString;
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

    qDebug() << "old value == " << m_grid[row][col];
    qDebug() << "new value == " << value;

    m_grid[row][col] = value;
    // emit gridUpdated();

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
