// SudokuPopup.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        border.width: 1
        color: "#2f3136"
        radius: 8
        height: 40
        width: 90
        anchors.centerIn: parent
    }

    GameButton {
        buttonText: "Resume"
        onButtonClicked: resumeClicked()
        buttonRadius: 6
        buttonWidth: 80
        buttonHeight: 30
        anchors.centerIn: parent
        buttonTextPixelSize: 16
    }

    signal resumeClicked()


}
