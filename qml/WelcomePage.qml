import QtQuick 2.15
// import QtQuick.Controls 2.15
import QtQuick.Controls.Fusion 2.15
import QtQuick.Layouts 1.15

Item {
    signal soloSelected()

    Rectangle {
        anchors.fill: parent
        color: "#2f3136"

        ColumnLayout {
            anchors {
                fill: parent
                margins: 20 // Margin from parent edges
            }
            spacing: 20

            Text {
                text: "SudokuVS"
                font.pixelSize: 32 // Adjust font size as needed
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                Layout.alignment: Qt.AlignHCenter // Center the text horizontally
            }

            ColumnLayout {
                spacing: 20
                Layout.alignment: Qt.AlignHCenter // Center the ColumnLayout horizontally

                Button {
                    text: "Solo"
                    onClicked: soloSelected()
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                }

                Button {
                    text: "Versus"
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                    // Implement Versus functionality here
                }

                Button {
                    text: "Settings"
                    Layout.minimumWidth: 100 // Set a minimum width for the button
                    Layout.alignment: Qt.AlignHCenter // Center the button horizontally
                    // Implement Settings functionality here
                }
            }
        }
    }
}
