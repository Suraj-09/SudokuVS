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
        return 0;
    }
