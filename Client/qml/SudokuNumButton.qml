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
        color: "white"
        border.color: "black"
        border.width: 3
        radius: 8 // Optional: for rounded corners
    }
    font.pixelSize: 28
    contentItem: Text {
        text: sudokuNumButton.text
        color: "black"
        font.pixelSize: sudokuNumButton.font.pixelSize  // Inherit the font size from the button
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent  // Ensure text fills the entire button area
    }
}
