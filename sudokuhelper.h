#ifndef SUDOKUHELPER_H
#define SUDOKUHELPER_H

#include <QObject>

class SudokuHelper : public QObject
{
    Q_OBJECT
public:
    explicit SudokuHelper(QObject *parent = nullptr);
    Q_INVOKABLE bool loadFromFile(const QString &filePath);
    Q_INVOKABLE int getCellValue(int row, int col) const;
    Q_INVOKABLE QVector<QVector<int>> getGrid() const;


signals:
    void puzzleLoaded();

private:
    QVector<QVector<int>> m_grid;

    void parseLine(const QString &line, int row);
};

#endif // SUDOKUHELPER_H
