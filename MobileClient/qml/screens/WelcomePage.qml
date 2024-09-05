import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15
import "qrc:/qml/components"


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
            spacing: 30

            Text {
                text: "SudokuVS"
                font.pixelSize: 64
                font.bold: true
                font.family: "Roboto"
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter
            }

            ColumnLayout {
                spacing: 20
                Layout.alignment: Qt.AlignHCenter

                GameButton {
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonText: "SOLO"
                    buttonTextPixelSize: 24
                    buttonBold: true
                    onButtonClicked: soloSelected()
                }

                GameButton {
                    buttonText: "VERSUS"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonTextPixelSize: 24
                    buttonBold: true
                    onButtonClicked: versusSelected()
                }

                GameButton {
                    buttonText: "SETTINGS"
                    buttonWidth: 160
                    buttonHeight: 50
                    buttonTextPixelSize: 24
                    buttonBold: true
                    visible: false
                }
            }
        }
    }
}
