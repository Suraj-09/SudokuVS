import QtQuick 2.15
import QtQuick.Controls.Fusion 2.15


TextField {
    property int index: -1
    property int predefinedNumber: 0
    property int selectedNum: 0

    property bool selected: false // New property for highlighting
    property bool highlighted: false // New property for highlighting
    property bool valid: true
    property bool hidden: false

    readOnly: predefinedNumber !== 0

    signal numberChanged(int index, int newNumber)
    signal cellClicked(int index) // Define the cellClicked signal

    property int leftBorder: 1
    property int rightBorder: 1
    property int topBorder: 1
    property int bottomBorder: 1

    width: 40
    height: 40
    font.pixelSize: 24
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    maximumLength: 1


    // Styling
    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        border.width: 1
        color: getColor()
    }

    // Dynamic text assignment based on predefinedNumber
    text: predefinedNumber !== 0 ? predefinedNumber.toString() : ""
    color: (hidden) ? "white" : (readOnly) ? "black" : (!valid) ? "red" : "dark blue"

    // Input validation
    validator: IntValidator {
        bottom: 1
        top: 9
    }

    // Handle text changes
    onTextChanged: {
        if (!readOnly) {
            var num = parseInt(text);
            if (!isNaN(num) && num >= 1 && num <= 9) {
                numberChanged(index, num);
            } else {
                text = ""; // Clear invalid input including 0
            }
        }
    }

    // Highlight the row, column, and 3x3 grid on focus
    onActiveFocusChanged: {
        if (activeFocus) {
            clearHighlights();

            selected = true;
            // if (selectedNum !== 0 && predefinedNumber === selectedNum) {
            //     selected = true;
            // }

            cellClicked(index);
            highlightCells(index);

        }
    }

    CustomBorder {
        commonBorder: false
        lBorderwidth: leftBorder
        rBorderwidth: rightBorder
        tBorderwidth: topBorder
        bBorderwidth: bottomBorder
        borderColor: "black"
    }

    function getColor() {
        if (hidden) {
            return "white";
        } else if (selected) {
            return "lightblue";
        } else if (highlighted) {
            return "#ddf7f7";
        } else if (!valid) {
            return "#FFBCAD"
        } else {
            return "white";
        }
    }

}
