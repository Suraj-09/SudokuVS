#ifndef SUDOKUHELPER_H
#define SUDOKUHELPER_H

#include <QObject>

class SudokuHelper : public QObject
{
    Q_OBJECT
public:
    explicit SudokuHelper(QObject *parent = nullptr);
    Q_INVOKABLE bool loadFromDatabase(int difficulty);
    Q_INVOKABLE QString loadStringFromDatabase(int difficulty);
    Q_INVOKABLE void parseGridString(const QString &gridString);
    Q_INVOKABLE void parseString(const QString &gridString);
    Q_INVOKABLE bool loadFromFile(const QString &filePath);
    Q_INVOKABLE int getCellValue(int row, int col) const;
    Q_INVOKABLE QVector<QVector<int>> getGrid() const;
    Q_INVOKABLE bool setCellValue(int row, int col, int value);
    Q_INVOKABLE bool isCellValid(int row, int col) const;



signals:
    void puzzleLoaded();
    void gridUpdated();

private:
    QVector<QVector<int>> m_grid;

    void parseLine(const QString &line, int row);
};

#endif // SUDOKUHELPER_H
