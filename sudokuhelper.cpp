#include "sudokuhelper.h"
#include <QFile>
#include <QTextStream>
#include <QCoreApplication>
#include <QDebug>
#include <QDir>



SudokuHelper::SudokuHelper(QObject *parent)
    : QObject{parent} {}


QVector<QVector<int>> SudokuHelper::getGrid() const
{
    return m_grid;
}

    bool SudokuHelper::loadFromFile(const QString &filePath) {

        // QDir currentDir = QDir::current();
        // qDebug() << "Current directory:" << currentDir.absolutePath();

        // qInfo() << filePath;
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
            if (line.isEmpty())
                continue;
            parseLine(line, row);
            ++row;
        }

        file.close();
        emit puzzleLoaded();
        return true;
    }

    void SudokuHelper::parseLine(const QString &line, int row)
    {
        QVector<int> rowValues;
        for (int col = 0; col < 9 && col < line.size(); ++col) {
            QChar ch = line.at(col);
            int num = ch.digitValue(); // Convert character to integer
            rowValues.push_back(num);
        }
        m_grid.push_back(rowValues);
    }

    int SudokuHelper::getCellValue(int row, int col) const
    {
        if (row < 0 || row >= 9 || col < 0 || col >= 9)
            return 0;

        return m_grid[row][col];
    }

    bool SudokuHelper::setCellValue(int row, int col, int value) {
        if (row < 0 || row >= 9 || col < 0 || col >= 9)
            return false;

        m_grid[row][col] = value;
        emit gridUpdated();

        return isCellValid(row, col);
    }

    bool SudokuHelper::isCellValid(int row, int col) const {
        int value = getCellValue(row, col);
        if (value == 0) return true; // Empty cells are always valid

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
