import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15

Item {
    signal backClicked()
    signal createGame()
    signal joinGame()

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 20
            }
            spacing: 20

            Text {
                text: "SudokuVS"
                font.pixelSize: 32
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }


            ColumnLayout {
                spacing: 20
                Layout.alignment: Qt.AlignHCenter

                Button {
                    text: "Create Game"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: createGame()
                }

                Button {
                    text: "Join Game"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: joinGame()
                }

                Button {
                    text: "Back"
                    onClicked: backClicked()
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }

        }
    }
}
