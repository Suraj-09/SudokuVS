// SudokuNumButton.qml
import QtQuick 2.15
// import QtQuick.Controls.Basic 2.15
import QtQuick.Controls.Fusion 2.15 // Import the Fusion style

Button {
    id: sudokuNumButton
    width: 50
    height: 50
    background: Rectangle {
        implicitWidth: 50
        implicitHeight: 50
        color: (sudokuNumButton.text == "<") ? "#34495e" : "white"
        // border.color: (sudokuNumButton.text == "<") ? "white" : "black"
        // border.width: 3
        radius: 8
    }
    font.pixelSize: 28
    contentItem: Text {
        text: sudokuNumButton.text
        color: (sudokuNumButton.text == "<") ? "white" : "black"
        font.pixelSize: sudokuNumButton.font.pixelSize
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
    }
}
