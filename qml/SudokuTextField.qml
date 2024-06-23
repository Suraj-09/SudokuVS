import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Fusion 2.15 // Import the Fusion style


TextField {
    property int index: -1
    property int predefinedNumber: 0
    property bool highlighted: false // New property for highlighting


    width: 40
    height: 40
    font.pixelSize: 16
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    maximumLength: 1

    // Styling
    background: Rectangle {
        implicitWidth: parent.width
        implicitHeight: parent.height
        border.width: 1
        color: parent.focus ? "lightblue" : (highlighted ? "#ddf7f7" : "white")

    }

    // Dynamic text assignment based on predefinedNumber
    text: predefinedNumber !== 0 ? predefinedNumber.toString() : ""

    // Input validation
    validator: IntValidator {
        bottom: 1
        top: 9
    }

    // Make the text field read-only if it's a predefined number
    readOnly: predefinedNumber !== 0

    signal numberChanged(int index, int newNumber)

    // Handle text changes
    onTextChanged: {
        if (!readOnly) {
            var num = parseInt(text);
            if (!isNaN(num) && num >= 1 && num <= 9) {
                numberChanged(index, num);
            } else {
                numberChanged(index, 0); // Handle invalid input by setting it to 0
            }
        }
    }

    // Highlight the row, column, and 3x3 grid on focus
    onActiveFocusChanged: {
        if (activeFocus) {
            highlightCells(index);
        } else {
            clearHighlights();
        }
    }
}

// import QtQuick 2.15
// import QtQuick.Controls 2.15

// TextField {
//     property int index: -1
//     property int predefinedNumber: 0

//     width: 40
//     height: 40
//     font.pixelSize: 16
//     verticalAlignment: Text.AlignVCenter
//     horizontalAlignment: Text.AlignHCenter
//     maximumLength: 1

//     // Dynamic text assignment based on predefinedNumber
//     text: predefinedNumber !== 0 ? predefinedNumber.toString() : ""

//     // Input validation
//     validator: IntValidator {
//         bottom: 1
//         top: 9
//     }

//     // Make the text field read-only if it's a predefined number
//     readOnly: predefinedNumber !== 0

//     // // Set background color based on validity
//     // background: Rectangle {
//     //     color: isValid ? "white" : "red"
//     // }

//     signal numberChanged(int index, int newNumber)

//     // Handle text changes
//     onTextChanged: {
//         if (!readOnly) {
//             var num = parseInt(text);
//             if (!isNaN(num) && num >= 1 && num <= 9) {
//                 numberChanged(index, num);
//             } else {
//                 numberChanged(index, 0); // Handle invalid input by setting it to 0
//             }
//         }
//     }
// }
