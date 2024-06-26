// SudokuPopup.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15

Popup {
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        border.width: 1
        color: "#2f3136"
        radius: 10
    }

    RoundButton {
        text: "Resume"
        onClicked: {
            resumeClicked()
        }
        radius: 10
    }

    signal resumeClicked()


}
