// SudokuPopup.qml
import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 2.15
import "qrc:/qml/components"


Popup {
    width: 300
    height: 120
    closePolicy: Popup.NoAutoClose

    background: Rectangle {
        border.width: 1
        color: "#2f3136"
        radius: 5
    }

    ColumnLayout {
        Layout.fillWidth: true
        anchors.centerIn: parent
        spacing: 10
         anchors.horizontalCenter: parent.horizontalCenter
        Text {
            text: "Are you sure you want to quit?"
            font.pixelSize: 20
            color: "white"
        }
        Text {
            text: "Difficulty: " + difficultyText
            font.pixelSize: 16
            color: "white"
        }

        RowLayout {
            spacing: 20
            Layout.alignment: Qt.AlignHCenter

            Button {
                text: "Ok"
                onClicked: {
                    okClicked()
                }
            }
            Button {
                text: "Cancel"
                onClicked: {
                    cancelClicked()
                }
            }
        }
    }

    signal okClicked()
    signal cancelClicked()

    property string difficultyText: ""
}
