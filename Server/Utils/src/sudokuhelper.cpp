#include "../includes/sudokuhelper.h"

SudokuHelper::SudokuHelper(QObject *parent) : QObject{parent} {
    srand(static_cast<unsigned int>(time(nullptr)));
    
    QCoreApplication::addLibraryPath(QCoreApplication::applicationDirPath() + "/../plugins/sqldrivers");

    // qDebug() << QCoreApplication::applicationDirPath() + "/../../Utils/databases.db";

    QString dbPath = QCoreApplication::applicationDirPath() + "/../../Utils/databases/sudoku.db";
    qDebug() << "database path = " << dbPath;
    // qDebug() << "Library Paths:" << QCoreApplication::libraryPaths();
    // qDebug()  <<  QSqlDatabase::drivers();
    m_database = QSqlDatabase::addDatabase("QSQLITE");

    m_database.setDatabaseName(dbPath);

    if (!m_database.open()) {
        qWarning() << "Could not open database:" << dbPath;
        // return false;
    }

}

QVector<QVector<int>> SudokuHelper::getGrid() const { return m_grid; }

bool SudokuHelper::loadFromDatabase(int difficulty) {

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
    // // QString dbPath = SUDOKU_DB_PATH;
    // QString dbPath = "C:/code/qt/QtQuick/SudokuVS/Utils/databases/sudoku.db";
    // // QString dbPath = "/home/suraj/code/qt/SudokuVS/Utils/databases/sudoku.db";
    // QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    // db.setDatabaseName(dbPath);

    // if (!db.open()) {
    //     qWarning() << "Could not open database:" << dbPath;
    //     return "";
    // }

    qDebug() << difficulty;
    QSqlQuery query(m_database);
    // query.prepare("SELECT grid FROM sudoku_grids WHERE id = 51 ORDER BY RANDOM() LIMIT 1");
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
