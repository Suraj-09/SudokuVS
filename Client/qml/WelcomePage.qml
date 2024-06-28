import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15

Item {
    signal soloSelected()
    signal versusSelected()

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
                    text: "Solo"
                    onClicked: soloSelected()
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Versus"
                    onClicked: versusSelected()
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }

                Button {
                    text: "Settings"
                    Layout.minimumWidth: 100
                    Layout.alignment: Qt.AlignHCenter
                }
            }
        }
    }
}
