import QtQuick 2.15
import QtQuick.Controls 2.15

TextField {
    property int index: -1
    property int predefinedNumber: 0

    width: 40
    height: 40
    font.pixelSize: 16
    verticalAlignment: Text.AlignVCenter
    horizontalAlignment: Text.AlignHCenter
    maximumLength: 1

    // Dynamic text assignment based on predefinedNumber
    text: predefinedNumber !== 0 ? predefinedNumber.toString() : ""

    // Input validation
    validator: IntValidator {
        bottom: 1
        top: 9
    }

    // Make the text field read-only if it's a predefined number
    readOnly: predefinedNumber !== 0

    // // Set background color based on validity
    // background: Rectangle {
    //     color: isValid ? "white" : "red"
    // }

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
}
